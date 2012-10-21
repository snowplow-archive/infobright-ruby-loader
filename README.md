# Infobright Ruby Loader

## Overview

Infobright Ruby Loader (IRL) is a data loader for [Infobright Community Edition] [ice] (ICE) and Enterprise Edition (IEE), built in Ruby.

IRL was inspired by [ParaFlex] [paraflex], a Bash script from the Infobright team to perform parallel loading of ICE and IEE. 

IRL can be used in two ways:

1. **As a command-line tool** - i.e. as a direct alternative to ParaFlex. No Ruby expertise required
2. **As part of another application** - IRL is a Ruby gem with a Ruby API, so can be integrated into larger Ruby ETL processes (such as [SnowPlow's] [snowplow-repo])

## Main differences from ParaFlex

The main differences between IRL and ParaFlex are as follows:

1. IRL can be integrated into Ruby apps (see above)
2. IRL lets you specify the Infobright username and/or password
2. IRL lets you specify the data delimiter and encloser
3. IRL allows multiple loads to the same table - it just runs them in series, not in parallel
4. IRL can be fed a directory of files, as well as a file list

## Installation

### Overview

To add.

### For command-line use

You can install IRL like so:

    $ gem install infobright-loader

### For use in your own application

Add this line to your application's Gemfile:

```ruby
gem 'infobright-loader'
```

And then execute:

    $ bundle

## Usage

### Operation modes

IRL has two main ways of operating:

1. Loading all the files from a specific directory into a specific table
2. Loading a set of tables from a set of files (where each table can have multiple files loaded into it)

Both modes of use are available whether you are running IRL from the command-line or from another Ruby application:

### From the command-line

You can use IRL from the command-line:

    $ bundle exec infobright-loader -v
    infobright-loader 0.0.1

#### Usage options

The usage options look like this:

Usage: infobright-loader [options]

    Specify a control file:
        -c, --control FILE               control file
        -x, --processes INT              optional number of parallel processes to run *

    Or load a table from a folder of data files:
        -d, --db NAME                    database name *
        -u, --username NAME              database username *
        -p, --password NAME              database password *
        -t, --table NAME                 table to load data files into
        -f, --folder DIR                 directory containing data files to load
        -s, --separator CHAR             optional field separator, defaults to pipe bar (|) *
        -e, --encloser CHAR              optional field encloser, defaults to none *

    * overrides the same setting in the control file if control file also specified

    Common options:
        -h, --help                       Show this message
        -v, --version                    Show version

In other words, you can run IRL from the command-line in two ways:

1. With `--control` specifying a control file containing a list of tables to load, each with a list of files
2. With `--db`, `--table` and `--folder` to load all the files from a specific directory into a single database table

As an added bonus, if you are using a control file you can still specify the asterisked parameters at the
command-line, to override the settings found in your control file.

#### Control file format

You can find a template control file in the repository as [`control-file/template.yml`] [control-file]. Its contents
is as follows:

```yaml
# Example control file for Infobright Ruby Loader

# Can be overridden at the command line...
:load:
  :processes: ADD HERE
:database:
  :name: ADD HERE
  :username: ADD HERE # Or leave blank to default to the user running the script
  :password: ADD HERE # Or leave blank if no password
:data_format:
  :separator: ADD HERE
  :encloser: ADD HERE # Or leave blank if no encloser
# ... end of variables overridable at command line.

# Map of tables to populate, along with files to load for each table
:data_loads:
  # For each table, list the data files to load
  TABLE_NAME_1:
    - PATH/TO/FILE-1
    - PATH/TO/FILE-2
  TABLE_NAME_2:
    - PATH/TO/FILE-3
    - PATH/TO/FILE-4
```

### From your own application

Using IRL from your own Ruby application (e.g. an ETL process) is quite straightforward.

First require the necessary file:

```ruby
require 'infobright-loader/loader'
```

Now populate a `DbConfig` struct:

```ruby
db = InfobrightLoader::Db::DbConfig.new('my-db', 'my-db-user', nil) # No password
```

And now you're ready to load either a single table or a hash of tables:

#### Load a single table

Loading a single table from a folder is quite straightforward:

```ruby
InfobrightLoader::Loader::load_from_folder(
  '/data/snowplow/etl-fla/latest', # folder
  'snowplow_events',               # table
  db,                              # database config
  '/t',                            # field separator
  ''                               # field encloser
)
```

Note that the last two arguments are optional - they default to the pipe bar (|) and empty () respectively.

#### Load a hash of tables

To load a hash of tables, let's first create the hash:

```ruby
load_hash = {}
load_hash[impressions] = ['/tmp/imps-1', '/tmp/imps-2', '/tmp/imps-3']
load_hash[clicks] = ['/tmp/clicks-1', '/tmp/clicks-2']
load_hash[conversions] = ['/tmp/convs-1', '/tmp/convs-2', '/tmp/convs-4', '/tmp/convs-4']
load_hash[bids] = ['/tmp/bids-1', '/tmp/bids-2', '/tmp/bids-4', '/tmp/bids-4']
```

Now we can run a parallel load of the tables:

```ruby
InfobrightLoader::Loader::load_from_hash(
  load_hash, # hash of tables to load into
  db,        # database config
  3,         # number of table loads to run in parallel (using Ruby threads)
  '/t',      # field separator
  ''         # field encloser
)
```

The last three arguments are optional:

* Number of processes defaults to 10 or the number of tables to populate, whichever is lower
* The field separator defaults to the pipe bar (|)
* The field encloser defaults to empty ()

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

Infobright Ruby Loader is copyright 2012 SnowPlow Analytics Ltd.

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[ice]: http://www.infobright.org/
[paraflex]: http://www.infobright.org/Blog/Entry/unscripted/
[snowplow-repo]: https://github.com/snowplow/snowplow
[control-file]: https://github.com/snowplow/infobright-ruby-loader/blob/master/control-file/template.yml
[license]: http://www.apache.org/licenses/LICENSE-2.0