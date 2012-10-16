#!/bin/bash
###########################################################
###                   Infobright 2009                   ###
###           Developed by: Client Services             ###
###           Authors: Carl Gelbart, David Lutz         ###
###                     Version 1.1                     ###
###                                                     ###
### v0.0: David Lutz   - design specification           ###
### v0.1: Carl Gelbart - orig interpretation of spec    ###
### v0.2: David Lutz   - hardening, doc and conversion  ###
### v0.3: Carl Gelbart - fix echo output behavior       ###
### v0.4: David Lutz   - add 'script load only' option  ###
### v0.5: David Lutz   - change usage messsage          ###
### v0.6: David Lutz   - do not check db/server for     ###
###                      script-only mode               ###
### v0.7: David Lutz   - add doc from Product Mgmt pres ###
### v1.0: David Lutz   - packaged for public download   ###
### v1.1: David Lutz   - replace hardcoded LOG naming   ###
###                                                     ###
#
# 
# The MIT License 
# 
# Copyright (c) 2009 Infobright Inc. 
# 
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions: 
# 
# The above copyright notice and this permission notice shall be 
# included in all copies or substantial portions of the Software. 
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
# OTHER DEALINGS IN THE SOFTWARE. 
# 
###########################################################
# v0.7
# Purposes
# + Eliminate need to write any LOAD scripts
# + Allow parallel execution of LOAD streams
# + Allow constant parallelism of LOAD streams
# 
# Benefits
# + A script – execute from cmd line, scripts, ETL
# + Single control file, single execution command
# + Can also generate SQL LOAD script
# + Maximum, flexible parallelism of data loading
# 
# Original Proposal
# A single load script that accepts a parameter for the
# number of parallel processes one might want running for
# a given load control file.
# 
# One could fire up X processes of the load utility that
# read from the same queue and each would process the
# next data file/table in the list.
# 
# When a load process is finished, each process goes back
# to the stack for the next pair to load.  All X number
# of processes are reading from the same queue. 
# 
# Remaining issues
# + Special case of 1 parallel process
# + Script assumes mysql-ib executable
# + Should add delimiters and enclosure characters to control
#   file
# + No current reference to @bh_dataformat
# + No current check for multiple occurrences of the same table
#   more than once in control file
# v0.7 
# 
# Usage documentation
# 
# Usage: [scriptname] <database> <control file> <processes>
#
# Sript expects to be passed the name of the database to be
# loaded.
#
# Script expects fo find a single, fully-qualified file name
# that contains one line for each file to be loaded and its
# associated table to be loaded in a single value pair.
#
# Script expects to be passed the number of concurrent load
# processes to execute.
#
# As of this writing, no attempt to validate the file format
# is made and no other validation of proper Infobright
# loading methodology is enforced, such as only one entry
# per table.
#
# Additional development and hardening will be delegated to
# Prodcut Management, Engineering and Development.
#
###########################################################
# Assumption(s):
#
# The control file is of the format
#   file table
#   file table
#   etc.
# That is:
#   '/path/file.extension'[space character]'table name'
#   '/path/file.extension'[space character]'table name'
#   etc.
#
# It's also assumed that the data file format is pipe bar
# ('|')delimited with no enclosure character. This could
# probably be included in the first line of the control file
# as individual parameters or the complete 'FIELDS' syntax.
#
###########################################################
# Exit codes
#
# 0 = successful
# 1 = general, unspecified error - check log file
# 2 = improper number of parameters provided
# 3 = cannot connect to database server
# 4 = cannot connect to specified database
# 5 = control file does not exist, cannot be read, or is empty
# 6 = number of parallel processes is not a positive integer
# 7 = load data file does not exist or cannot be read
# 8 = load table does not exist
# 9 = load statement failed
#
###########################################################

# input parameters
if [ $# != 3 ]; then
    echo; echo 'syntax: '$0' <database> <control file> <processes>'; echo # v0.5
    exit 2
else
    # assign parameters
    DATA=$1
    FILE=$2
    CONC=$3
fi

# log is written to user's $HOME directory to prevent permission issues
# when executed multiple times the log file is appended
LOG=~/$0.log # v1.1
TMP=/tmp/load.line
SQL=`locate mysql-ib`

# validate parameters

# add check for database server
if [ $CONC -ne 0 ]; then # v0.6
    $SQL -e \\q > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo `date` >> $LOG
        echo "Default MySQL server cannot be found or is not running."\
        | tee -a $LOG
        exit 3
    fi
fi # v0.6

# add check that database specified exists - $DATA
if [ $CONC -ne 0 ]; then # v0.6
    $SQL -D $DATA -e \\q > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo `date` >> $LOG
        echo "Database "$DATA" cannot be found or user lacks sufficient privileges." | tee -a $LOG
        exit 4
    fi
fi # v0.6

# add check that file exists - $FILE
if [ ! -f $FILE -o ! -r $FILE -o ! -s $FILE ]; then
    echo `date` >> $LOG
    echo "Control file "$FILE" does not exist, cannot be read, or is empty."\
    | tee -a $LOG
    exit 5
fi

# add check that concurrency parameter is a positive integer - $CONC
echo $CONC | grep [^0-9] > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo `date` >> $LOG
    echo "Parallel load processes "$CONC" is not a positive integer."\
    | tee -a $LOG
    exit 6
fi

# general output and logging
BEGS=$(date +%s)
BEGT=`date --rfc-3339='seconds'`
echo "Loading $DATA using $FILE concurrency of $CONC" | tee -a $LOG
echo "began $BEGT" | tee -a $LOG

# create SQL script file and write LOAD statements for future use or review
cat /dev/null > $LOG.sql

# initialize looping control values
files=0
procs=0
STATUS=0

###########################################################
# OPEN CONTROL FILE AND START PROCESSING VALUE PAIRS      #

while read lines; do

    # THIS CAN BE IMPROVED WITHOUT A TEMP FILE
    # parse control record
    echo $lines > $TMP
    LOADFILE=`cut -d' ' -f1 $TMP`
    LOADTABL=`cut -d' ' -f2 $TMP`

    # add check that file exists and can be read
    if [ ! -f $LOADFILE -o ! -r $LOADFILE -o ! -s $LOADFILE ]; then
        echo `date` >> $LOG
        echo "File "$LOADFILE" does not exist, cannot be read, or is empty."\
        | tee -a $LOG
        STATUs=7
        continue
    fi

    # add check that table exists
    echo "desc "$LOADTABL";" | $SQL -D $DATA > /dev/null 2>&1
    if [ $? -ne 0 ]; then
       echo "Load table "$LOADTABL" cannot be found." | tee -a $LOG
       echo "See log for details." | tee -a $LOG
       STATUS=8
       continue
    fi

    # sleep loop while concurrency has been reached
    # (there is no concurrency of $CONC equals 1)
    if [ $CONC -gt 1 ]; then
        procs=`jobs | wc -l`
        while [ $procs -ge  $CONC ]; do
            procs=`jobs | wc -l`
            sleep 1
        done
    fi
    files=$((files+1))

    #-----------------------------------------------------#
    # PROCESS CONTROL RECORD - LOAD DATA FILE INTO TABLE  #

    STRING="LOAD DATA INFILE '"$LOADFILE"' "
    STRING=$STRING"INTO TABLE "$LOADTABL" "
    STRING=$STRING"FIELDS TERMINATED BY '|' ENCLOSED BY ''; "

    echo $STRING | tee -a $LOG.sql
    # v0.4 - only script LOAD to SQL file if processes parm = 0
    if [ $CONC -eq 0 ]; then
        continue
    fi

    echo "$STRING" | $SQL -D $DATA &
    LOADSTAT=$?

    #-----------------------------------------------------#

    # error checking
    if [ $LOADSTAT -ne 0 ]; then
       STATUS=$LOADSTAT
       echo "Load of "$LOADFILE" into table "$LOADTABL" failed." | tee -a $LOG
       echo "See log for details." | tee -a $LOG
    fi
done < $FILE
###########################################################

wait # v.02

# clean up temp file(s)
rm -f $TMP

# general output and logging
ENDS=$(date +%s)
ENDT=`date --rfc-3339='seconds'`
echo "ended $ENDT" | tee -a $LOG

DIFF=$(( $ENDS - $BEGS ))
echo "duration "$DIFF" seconds" | tee -a $LOG

exit $STATUS
