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

    # Is mysql-ib running and the
    # Infobright server accessible?
    def running?
      ib = locate_mysql_ib
      `#{ib} -e \q > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :running?
  
    # Does the database exist and can
    # we access it?
    def db_exists?(db)
      ib = locate_mysql_ib
      `#{ib} -D #{db} -e \q > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :db_exists?

    # Does the table exist?
    def table_exists?(table, db)
      ib = locate_mysql_ib
      `echo "desc "#{table}";" | #{ib} -D #{db} > /dev/null 2>&1`
      ($?.to_i == 0)
    end
    module_function :table_exists?    

    # Load data
    def load_file(file, table, db, separator, encloser)
      # TODO
    end
    module_function :load_file

    private
    
    def locate_mysql_ib
      `locate mysql-ib`
    end
    module_function :locate_mysql_ib

  end
end