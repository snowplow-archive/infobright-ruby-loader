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

require 'infobright-loader/cli/config'
require 'infobright-loader/loader'

# Loader determines which load action to run.
#
# It's a selective wrapper around
# load_from_folder() and load_from_map()
module InfobrightLoader
  module Cli
    module Loader

      # Determine what type of config we have,
      # and then call the appropriate load
      def load(config)

        failures = []

        case config
        when InfobrightLoader::Cli::Config::LoadFolderConfig
          failures = InfobrightLoader::Loader::load_from_folder(
            config.folder,
            config.table,
            config.db,
            config.separator,
            config.encloser
          )

        when InfobrightLoader::Cli::Config::LoadHashConfig
          failures = InfobrightLoader::Loader::load_from_hash(
            config.load_hash,
            config.db,
            config.processes,
            config.separator,
            config.encloser
          )

        else
          raise ConfigError, "config argument passed to Cli::Loader::load() must be a LoadFolderConfig or a LoadHashConfig"
        end

        unless failures.empty?
          error = "Load of following files failed (reason in brackets):\n" + \
                  failures.map{|f| " - " + f}.join("\n")
          raise InfobrightLoader::Loader::LoadError, error
        end
      end
      module_function :load

    end
  end
end