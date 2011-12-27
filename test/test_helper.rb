# encoding: UTF-8
require 'rubygems'
require 'test/unit'
require 'stringio'

# this will enable testing the output of the CLI 
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end
end

# requiring cheatorious
require File.expand_path(File.dirname(__FILE__) + '/../lib/cheatorious')

class Dir
  def self.home
    File.expand_path(File.join("."))
  end
end
