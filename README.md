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
2. IRL allows you to specify the data delimiter and encloser
3. IRL allows multiple loads to the same table - it just runs them in series, not in parallel
4. IRL can be fed a directory of files, as well as a file list

## Installation

Add this line to your application's Gemfile:

    gem 'infobright-loader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infobright-loader

## Usage

### Operation modes

IRL has two main ways of operating:

1. Loading all the files from a specific directory into a specific table
2. Loading a set of tables from a set of files (where each table can have multiple files loaded into it)

Both modes of use are available whether you are running IRL from the command-line or from another Ruby application:

### From the command-line

You can use IRL from the command-line. The usage options look like this:

    Usage: infobright-loader [options]

    Specify a control file:
        -c, --control FILE               control file

    Or load a table from a folder of data files:
        -d, --db NAME                    database name *
        -t, --table NAME                 table to load data files into
        -f, --folder DIR                 directory containing data files to load
        -s, --separator CHAR             optional field separator, defaults to pipe bar (|) *
        -e, --encloser CHAR              optional field encloser, defaults to none *
        -p, --processes NUM              how many parallel processes to use, defaults to 10 * 

    * overrides the same setting in the control file if control file also specified

    Common options:
        -h, --help                       Show this message
        -v, --version                    Show version

In other words, you can run IRL from the command-line in two ways:

1. With `--control` to load a set of tables from a set of files
2. With `--db`, `--table` and `--folder` to load all the files from a specific directory into a specific table

As an added bonus, if you are using a control file you can specify the asterisked parameters at the command-line
to override the settings found in the control file.

### Via its API

Usage instructions to come.

## Hacking locally

    $ gem build infobright-loader.gemspec
    $ sudo gem install infobright-loader-0.0.1.gem
    $ bundle install

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
[license]: http://www.apache.org/licenses/LICENSE-2.0