# Infobright Ruby Loader

## Overview

Infobright Ruby Loader is a data loader for Infobright Community Edition (ICE) and Enterprise Edition (IEE), built in Ruby.

Infobright Ruby Loader was inspired by [ParaFlex] [paraflex], a Bash script from the Infobright team to perform parallel loading of ICE and IEE. 

## Main differences from ParaFlex

The main differences between Infobright Ruby Loader and ParaFlex are as follows:

1. Infobright Ruby Loader (IRL) is a Bundler Gem and has a Ruby API, so can be added easily into larger Ruby ETL processes
2. IRL allows you to specify the data delimiter and encloser as a global configuration setting
3. IRL allows multiple loads to the same table - it just runs them in series, not parallel
4. IRL can be used to load all the files from a directory as well as process a file list

## Roadmap

It would be nice to wrap just the data load task as a [Resque] [resque] job with a `perform` method.

## Copyright and license

cloudfront-log-deserializer is copyright 2012 SnowPlow Analytics Ltd.

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[paraflex]: http://www.infobright.org/Blog/Entry/unscripted/
[resque]: https://github.com/defunkt/resque/
[license]: http://www.apache.org/licenses/LICENSE-2.0