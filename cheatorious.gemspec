# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

version_file = File.expand_path "../GEM_VERSION", __FILE__
File.delete version_file if File.exists? version_file

require 'step-up'
require 'cheatorious'

Gem::Specification.new do |s|
  s.name          = "cheatorious"
  s.version       = Cheatorious::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = "generator of simple, searchable, command line cheatsheets"
  s.bindir        = "bin"
  s.executables   = ["cheatorious"]
  s.require_paths = ['lib']
  excepts = %w[
    .gitignore
    cheatsheets.gemspec
    Gemfile
    Gemfile.lock
    Rakefile
  ]
  tests = `git ls-files -- {script,test}/*`.split("\n")
  s.files = `git ls-files`.split("\n") - excepts - tests + %w[GEM_VERSION]

  s.author        = "Luis Cipriani"
  s.email         = "lfcipriani@gmail.com"
  s.homepage      = "https://github.com/abril/cheatorious"

  s.add_runtime_dependency('thor', '>= 0.14.6')

  # s.add_development_dependency('cover_me')
  # s.add_development_dependency('ruby-debug19')
  s.add_development_dependency('step-up')
end
