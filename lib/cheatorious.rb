# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"

# Gem requirements
module Cheatorious
  autoload :CheatSheet, "cheatorious/cheatsheet"
  autoload :VERSION   , 'cheatorious/version'
end
