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

require 'optparse'
require 'date'
require 'yaml'

# Config module to hold functions related to CLI argument parsing
# and config file reading to support the daily ETL job.
module Config

  # What are we called?
  SCRIPT_NAME = InfobrightLoader::NAME

  class ConfigError < ArgumentError; end

  # Return the configuration loaded from the supplied YAML file, plus
  # the additional constants above.
  def Config.get_config()

    options = Config.parse_args()
    config = YAML.load_file(options[:config])

    # TODO

    config
  end

  # Parse the command-line arguments
  # Returns: the hash of parsed options
  def Config.parse_args()

    # Handle command-line arguments
    options = {}
    optparse = OptionParser.new do |opts|

      opts.banner = "Usage: %s [options]" % SCRIPT_NAME
      opts.separator ""
      opts.separator "Specify a control file:"

      opts.on('-c', '--control FILE', 'control file') { |config| options[:control] = config }

      opts.separator ""
      opts.separator "Or load a table from a folder of data files:"

      opts.on('-d', '--db NAME', 'database name *') { |config| options[:db] = config }
      opts.on('-t', '--table NAME', 'table to load data files into') { |config| options[:table] = config }
      opts.on('-f', '--folder DIR', 'directory containing data files to load') { |config| options[:folder] = config }
      opts.on('-s', '--separator CHAR', 'optional field separator, defaults to pipe bar (|) *') { |config| options[:separator] = config }
      opts.on('-e', '--encloser CHAR', 'optional field encloser, defaults to none *') { |config| options[:encloser] = config }

      opts.separator ""
      opts.separator "* overrides the same setting in control file if control file also specified"

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail('-h', '--help', 'Show this message') { puts opts; exit }
      opts.on_tail('-v', "--version", "Show version") do
        puts "%s %s" % [SCRIPT_NAME, InfobrightLoader::VERSION]
        exit
      end
    end

    # Set command-line defaults only if no control file given
    if options[:control].nil?
      options[:separator] ||= '|'
      options[:encloser]  ||= ''
    end

    # Check the mandatory arguments
    begin
      optparse.parse!
      
      # If no control file given, most of the options are required
      if options[:control].nil?

        mandatory = [:db, :table, :folder, :separator, :encloser]
        missing = mandatory.select{ |param| options[param].nil? }
        if not missing.empty?
          raise ConfigError, "No control file specified, so missing options: #{missing.join(', ')}\n#{optparse}"
        end
      else
        unless options[:folder].nil? and options[:table].nil?
          raise ConfigError, "Specifying a control file as well as a folder and/or table does not make sense"
        end
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      raise ConfigError, "#{$!.to_s}\n#{optparse}"
    end

    # If we have a folder, check it exists...
    unless options[:folder].nil?
      # TODO: folder exists check?
      raise ConfigError, "Specified folder #{options[:folder]} does not exist"
    end

    options
  end

end