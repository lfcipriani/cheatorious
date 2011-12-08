# encoding: UTF-8
lib = File.expand_path File.join(*%w[.. .. lib]), __FILE__
$:.unshift lib unless $:.include? lib
version_file = File.expand_path "../../GEM_VERSION", __FILE__
exec "rm #{version_file}" if File.exists?(version_file)
require "rubygems"
require "step-up"
require "cheatorious"
