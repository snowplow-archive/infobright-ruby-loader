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
module InfobrightLoader
  module Cli
    module Config

      # What are we called?
      SCRIPT_NAME = InfobrightLoader::NAME

      # For errors
      class ConfigError < ArgumentError; end

      # Configuration for loading all the files from a specific directory into
      # a specific table
      LoadHashConfig = Struct.new(:load_hash, :db, :processes, :separator, :encloser)
      
      # Configuration for loading a set of tables from a set of files (where
      # each table can have multiple files loaded into it)
      LoadFolderConfig = Struct.new(:folder, :table, :db, :processes, :separator, :encloser)

      # Validates and returns the configuration.
      #
      # The configuration returned will either be
      # a LoadMapConfig or a LoadFolderConfig.
      def get_config()

        options = Config.parse_args()

        if options[:control].nil?

          config = LoadFolderConfig.new
          config.processes = options[:processes]
          config.db = options[:db] 
          config.separator = options[:separator]
          config.encloser = options[:encloser] 
          config.folder = options[:folder] 
          config.table = options[:table] 

        else

          yaml = YAML.load_file(options[:control])

          # Set the overridable fields if they haven't been overridden at the command-line
          config = LoadMapConfig.new
          get_or_else = lambda {|x, y| x.nil? ? y : x }
          config.processes = get_or_else.call(options[:processes], yaml[:load][:processes])
          config.db = get_or_else.call(options[:db], yaml[:database][:name])
          config.separator = get_or_else.call(options[:separator], yaml[:data_format][:separator])
          config.encloser = get_or_else.call(options[:encloser], yaml[:data_format][:encloser])

          # Finally grab the load map
          config.load_hash = yaml[:data_loads]
        end

        # Finally we can check that number of processes is a positive integer
        unless config.processes.to_i > 0
          raise ConfigError, "Parallel load processes '#{config.processes}' is not a positive integer"
        end
        config.processes = config.processes.to_i # A kitten dies, mutably.

        config # Return either our LoadFolderConfig or our LoadMapConfig
      end
      module_function :get_config

      # Parse the command-line arguments
      # Returns: the hash of parsed options
      def parse_args()

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
          opts.on('-p', '--processes INT', 'optional number of parallel processes to run, defaults to 10 *') { |config| options[:processes] = config }

          opts.separator ""
          opts.separator "* overrides the same setting in the control file if control file also specified"

          opts.separator ""
          opts.separator "Common options:"

          opts.on_tail('-h', '--help', 'Show this message') { puts opts; exit }
          opts.on_tail('-v', "--version", "Show version") do
            puts "%s %s" % [SCRIPT_NAME, InfobrightLoader::VERSION]
            exit
          end
        end

        # Run OptionParser's structural validation
        begin
          optparse.parse!
        rescue OptionParser::InvalidOption, OptionParser::MissingArgument
          raise ConfigError, "#{$!.to_s}\n#{optparse}"
        end

        # If no control file given, most of the options are required
        if options[:control].nil?

          # Set defaults if necessary
          options[:separator] ||= '|'
          options[:encloser]  ||= ''
          options[:processes] ||= '10'

          # First check we have all the options we need
          mandatory = [:db, :table, :folder]
          missing = mandatory.select{ |param| options[param].nil? }
          if not missing.empty?
            raise ConfigError, "No control file specified, so missing options: #{missing.join(', ')}\n#{optparse}"
          end

          # Check our folder exists and is not empty
          unless File.directory?(options[:folder])
            raise ConfigError, "Specified folder '#{options[:folder]}' not found"
          end
          if (Dir.entries(options[:folder]) - %w{ . .. }).empty?
            raise ConfigError, "Specified folder '#{options[:folder]}' is empty"
          end

          # Add trailing slash if needed to the folder
          trail = lambda {|str| return str[-1].chr != '/' ? str << '/' : str}
          options[:folder] = trail.call(options[:folder])

        # We are working with the control file
        else

          # Check we don't have a conflict of purpose
          unless options[:folder].nil? and options[:table].nil?
            raise ConfigError, "Specifying a control file as well as a folder and table does not make sense"
          end

          # Check the control file exists
          unless File.file?(options[:control])
            raise ConfigError, "Control file '#{options[:control]}' does not exist, or is not a file."
          end
        end

        options
      end
      module_function :parse_args

    end
  end
end