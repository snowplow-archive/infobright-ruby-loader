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

        # TODO: need to sort out arguments!

        if config.is_a? InfobrightLoader::Cli::Config::LoadFolderConfig
          InfobrightLoader::Loader::load_from_folder()
        elsif config.is_a? InfobrightLoader::Cli::Config::LoadMapConfig
          InfobrightLoader::Loader::load_from_map()
        else
          puts "ARGGGGGGGGGGGGGGGG"
        end
      end
      module_function :load

    end
  end
end