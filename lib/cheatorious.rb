# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"

# Gem requirements
require "cheatorious/cheatsheet"
module Cheatorious
  autoload :VERSION, 'cheatorious/version'
end
