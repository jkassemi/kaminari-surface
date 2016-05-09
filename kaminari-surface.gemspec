# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaminari/surface/version'

Gem::Specification.new do |gem|
  gem.name          = "kaminari-surface"
  gem.version       = Kaminari::Surface::VERSION
  gem.summary       = %q{Surface the final search result page when desirable}
  gem.description   = %q{An extension to Kaminari pagination that brings the final page of a search results to the surface, and prevents unnecessary paging requests.}
  gem.license       = "MIT"
  gem.authors       = ["James Kassemi"]
  gem.email         = "jkassemi@gmail.com"
  gem.homepage      = "https://github.com/jkassemi/kaminari-surface"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'kaminari', '~> 0.16'

  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'bundler', '~> 1'
  gem.add_development_dependency 'faker', '~> 1.4'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'

  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'data_mapper'
  gem.add_development_dependency 'dm-sqlite-adapter'
  gem.add_development_dependency 'kaminari-data_mapper'
  gem.add_development_dependency 'mongoid'
  gem.add_development_dependency 'kaminari-mongoid'
  gem.add_development_dependency 'mongo_mapper'
  gem.add_development_dependency 'kaminari-mongo_mapper'
end
