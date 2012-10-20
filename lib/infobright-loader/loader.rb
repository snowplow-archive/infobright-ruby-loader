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
    def load_from_folder(folder, table, db, processes=10, separator='|', encloser='')

      # Let's loop through and grab all absolute paths to all the files in this folder, recursively
      load_hash = {}
      load_hash[table] = Dir["#{folder}**/*"].find_all{|f| File.file?(f)}.map{|f| File.expand_path(f)}

      # Check we have some files to load
      unless load_hash[table].any?
        puts "No files to load in folder #{folder}" # TODO: move to Ruby logger?
        return
      end

      # Now we have converted the folder and table
      # into a map, we can use load_from_map()
      load_from_hash(load_hash, db, processes, separator, encloser)
    end
    module_function :load_from_folder

    # Load Infobright using a hash of
    # tables to filenames.
    def load_from_hash(load_hash, db, processes=10, separator='|', encloser='')

      # Check we have some tables
      t_count = load_hash.length

      case 
      when t_count == 0
        puts "We have no tables to populate" # TODO: move to Ruby logger?
        return
      when t_count < processes
        puts "We have only #{t_count} table(s) to populate, reducing processes from #{processes} to #{t_count}" # TODO: move to Ruby logger?
        processes = t_count
      end

      # Check we have more tables to load than processes.
      # TODO


    end
    module_function :load_from_hash

  end
end