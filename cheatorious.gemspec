# encoding: UTF-8
lib = File.expand_path('../lib' , __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'cheatorious/version'

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
  s.files = `git ls-files`.split("\n") - excepts - tests

  s.author        = "Luis Cipriani"
  s.email         = "lfcipriani@gmail.com"
  s.homepage      = "https://github.com/abril/cheatorious"

  s.add_runtime_dependency('thor', '>= 0.14.6')
  s.add_runtime_dependency('rainbow', '>= 1.1.3')
  s.add_runtime_dependency('hirb', '>= 0.6.0')

  s.add_development_dependency('step-up')
  s.add_development_dependency('rake')
end
