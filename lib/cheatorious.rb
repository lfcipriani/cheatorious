# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"

# Gem requirements
module Cheatorious
  autoload :CLI       , "cheatorious/cli"
  autoload :CheatSheet, "cheatorious/cheatsheet"
  autoload :Utils     , "cheatorious/utils"
  autoload :Search    , "cheatorious/search"
  autoload :Writer    , "cheatorious/writer"
  autoload :VERSION   , 'cheatorious/version'
end
