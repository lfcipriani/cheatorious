# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "rainbow"

# Adding Dir.home method if it's not available
# This method is the adapted from hirb rubygem
unless Dir.respond_to?(:home)
  class Dir
    def self.home
      ['HOME', 'USERPROFILE'].each {|e| return ENV[e] if ENV[e] }
      return "#{ENV['HOMEDRIVE']}#{ENV['HOMEPATH']}" if ENV['HOMEDRIVE'] && ENV['HOMEPATH']
      File.expand_path("~")
    rescue
      File::ALT_SEPARATOR ? "C:/" : "/"
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
