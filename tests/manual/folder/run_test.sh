#!/bin/bash
# Copyright (c) 2012 SnowPlow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Author::    Alex Dean (mailto:support@snowplowanalytics.com)
# Copyright:: Copyright (c) 2012 SnowPlow Analytics Ltd
# License::   Apache License Version 2.0

# input parameters
if [ $# != 2 ]; then
    echo; echo 'syntax: '$0' <username> <password>'; echo
    exit 1
else
    # assign parameters
    USERNAME=$1
    PASSWORD=$2
fi

echo "Running folder-based test..."
SQL=`locate mysql-ib`

echo "Setting up Infobright"
cat setup.sql | ${SQL} -u ${USERNAME} --password=${PASSWORD}

echo "Running Infobright Ruby Loader in folder mode"
bundle exec infobright-loader -d irl_tests -e \" -u ${USERNAME} -p ${PASSWORD} -t a -f data/a

echo "Verifying the load into Infobright - please visually inspect:"
cat verify.sql | ${SQL} -u ${USERNAME} --password=${PASSWORD}
