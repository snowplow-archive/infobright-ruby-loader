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

require 'infobright-loader/db'

module InfobrightLoader
  module Loader

    # For errors
    class LoadError < ArgumentError; end

    # Load a single table in Infobright with
    # the contents of a single folder
    def load_from_folder(folder, table, db, processes=10, separator='|', encloser='')

      # Let's loop through and grab all absolute paths to all the files in this folder, recursively
      load_hash = {}
      load_hash[table] = Dir["#{folder}**/*"].find_all{|f| File.file?(f)}.map{|f| File.expand_path(f)}

      # Check we have some files to load
      unless load_hash[table].any?
        raise LoadError, "No files to load in folder #{folder}"
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

      # Some validation about the load we're going to do
      case 
      when t_count == 0
        raise LoadError, "We have no tables to populate"
      when t_count < processes
        puts "We have only #{t_count} table(s) to populate, reducing processes from #{processes} to #{t_count}" # TODO: move to Ruby logger?
        processes = t_count
      end

      # Now let's check MySQL server is accessible
      unless InfobrightLoader::Db.running?
        raise LoadError, "Default MySQL server cannot be found or is not running"
      end

      # Now let's check that we can access the database
      unless InfobrightLoader::Db.db_exists?(db)
        raise LoadError, "Database #{db} cannot be found or user lacks sufficient privileges"
      end      

      # Now we're ready to start with the parallel load
      load_parallel(load_hash, db, processes, separator, encloser)

    end
    module_function :load_from_hash

    private

    # Perform a parallel load.
    def load_parallel(load_hash, db, processes, separator, encloser)

      # TODO: write this.

    end
    module_function :load_parallel

  end
end