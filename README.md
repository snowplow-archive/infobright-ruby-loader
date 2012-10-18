# Infobright Ruby Loader

## Overview

Infobright Ruby Loader (IRL) is a data loader for [Infobright Community Edition] [ice] (ICE) and Enterprise Edition (IEE), built in Ruby.

IRL was inspired by [ParaFlex] [paraflex], a Bash script from the Infobright team to perform parallel loading of ICE and IEE. 

## Main differences from ParaFlex

The main differences between IRL and ParaFlex are as follows:

1. As well as being a command-line tool, IRL is a Ruby gem with a Ruby API, so can be added easily into larger Ruby ETL processes
2. IRL allows you to specify the data delimiter and encloser as a global configuration setting
3. IRL allows multiple loads to the same table - it just runs them in series, not parallel
4. IRL can be fed a directory of files, as well as a file list

## Installation

Add this line to your application's Gemfile:

    gem 'infobright-loader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infobright-loader

## Usage

### From the command-line

You can also use IRL from the command-line.

REST OF USAGE INSTRUCTIONS TO COME

### Via its API

REST OF USAGE INSTRUCTIONS TO COME

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
[license]: http://www.apache.org/licenses/LICENSE-2.0