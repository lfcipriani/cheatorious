# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Cheatorious::Writer::TextTest < Test::Unit::TestCase

  def test_writer_duck_typing
    w = Cheatorious::Writer::Text.new
    
    assert w.respond_to?(:header)
    assert w.respond_to?(:footer)
    assert w.respond_to?(:section_start)
    assert w.respond_to?(:section_end)
    assert w.respond_to?(:entry)
    assert w.respond_to?(:result)
    
    # w = Cheatorious::Writer::Text.new(:name => "VIM", :author => "Luis Cipriani", :description => "Cool!", :version => "1.0.0")
    # 
    # w.header
    # w.section_start("Files")
    # w.entry("Save", ":w")
    # w.section_start("Opening")
    # w.entry("Save", ":w")
    # w.entry("Save1", ":w")
    # w.entry("Save2", ":w")
    # w.section_end
    # w.section_end
    # w.entry("Movement", "h", "j", "k", "l")
    # w.footer
    # w.result
  end

end
