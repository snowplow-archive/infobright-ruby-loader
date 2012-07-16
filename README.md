# Infobright Ruby Loader

## Overview

Infobright Ruby Loader is a data loader for Infobright Community Edition (ICE) and Enterprise Edition (IEE), built in Ruby.

Inspired by [ParaFlex] [paraflex], a Bash script from the Infobright team to perform parallel loading of ICE and IEE. 

## Main differences from ParaFlex

The main differences between Infobright Ruby Loader and ParaFlex are as follows:

1. Infobright Ruby Loader (IRL) is a Bundler Gem and has a Ruby API, so can be added easily into larger Ruby ETL processes
2. IRL allows you to specify the data delimiter and encloser as a global configuration setting
3. IRL allows multiple loads to the same table - it just runs them in series, not parallel
4. IRL can be used to load all the files from a directory as well as process a file list

## Roadmap

It would be nice to package just the data load task as a [Resque] [resque] job with a `perform` method.

[paraflex]: http://www.infobright.org/Blog/Entry/unscripted/
[resque]: https://github.com/defunkt/resque/