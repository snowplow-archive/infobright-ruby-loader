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
  module Db

    # Configuration for accessing an Infobright database.
    # :username and :password can be nil
    DbConfig = Struct.new(:name, :username, :password)

    # Is mysql-ib running and the
    # Infobright server accessible?
    def running?(db)
      ib = ib_command_from(db)
      `#{ib} -e \\\\q > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :running?
  
    # Does the database exist and can
    # we access it?
    def db_exists?(db)
      ib = ib_command_from(db)
      `#{ib} -D #{db.name} -e \\\\q > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :db_exists?

    # Does the table exist?
    def table_exists?(table, db)
      ib = ib_command_from(db)
      `echo "desc "#{table}";" | #{ib} -D #{db.name} > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :table_exists?    

    # Load data
    def load_file(file, table, db, separator='|', encloser='')

      # Have to escape the seperator and encloser if either is " or '
      escaper = lambda { |c| (c == '"' || c == "'") ? "\\" + c : c }
      separator = escaper.call(separator)
      encloser = escaper.call(encloser)

      ib = ib_command_from(db)
      load = "LOAD DATA INFILE '#{file}' " + \
             "INTO TABLE #{table} " + \
             "FIELDS TERMINATED BY '#{separator}' ENCLOSED BY '#{encloser}'; "

      `echo "#{load}" | #{ib} -D #{db.name}`
      ($?.to_i == 0)
    end
    module_function :load_file

    private
    
    # Get path to Infobright's mysql-ib client,
    # then add in username and password as
    # necessary
    def ib_command_from(db)
      `locate mysql-ib`[0...-1] + \
        (db.username.nil? ? '' : " -u #{db.username}") + \
        (db.password.nil? ? '' : " --password=#{db.password}")
    end
    module_function :ib_command_from

  end
end