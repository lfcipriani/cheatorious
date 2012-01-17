# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"

# Adding Dir.home method if it's not available
unless Dir.respond_to?(:home)
  class Dir
    def self.home
      File.expand_path(File.join("~"))
    end
  end
end

# Gem requirements
module Cheatorious
  autoload :CLI       , "cheatorious/cli"
  autoload :CheatSheet, "cheatorious/cheatsheet"
  autoload :Utils     , "cheatorious/utils"
  autoload :Search    , "cheatorious/search"
  autoload :Writer    , "cheatorious/writer"
  autoload :VERSION   , 'cheatorious/version'
end
