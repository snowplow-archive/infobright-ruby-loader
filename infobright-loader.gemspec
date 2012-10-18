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

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/infobright-loader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex Dean <support@snowplowanalytics.com>"]
  gem.email         = ["support@snowplowanalytics.com"]
  gem.description   = %q{Loads data files into Infobright}
  gem.summary       = %{Infobright Ruby Loader (IRL) is a data loader for Infobright Community Edition (ICE) and Enterprise Edition (IEE), built as a Ruby gem. Inspired by ParaFlex (the bash equivalent)}
  gem.homepage      = "http://snowplowanalytics.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = InfobrightLoader::NAME
  gem.version       = InfobrightLoader::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.require_paths = ["lib"]
end