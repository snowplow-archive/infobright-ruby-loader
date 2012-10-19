#!/usr/bin/env ruby

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

module InfobrightLoader
  module Loader

    # Load a single table in Infobright
    # with the contents of a single
    # folder
    def load_from_folder()

      puts "PLACEHOLDER: load_from_folder()"

      # Now we have converted the folder and table
      # into a map, we can use load_from_map()
      load_from_map()
    end
    module_function :load_from_folder

    # Load Infobright using a 'map' of
    # tables to filenames.
    def load_from_map()

      puts "PLACEHOLDER: load_from_map()"
    end
    module_function :load_from_map

  end
end