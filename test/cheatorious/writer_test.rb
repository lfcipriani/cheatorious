# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::WriterTest < Test::Unit::TestCase

  def test_writer_duck_typing
    assert true

    # write text written below when writing your own Writer ;-)
    #
    # w = Cheatorious::Writer::[your writer here].new
    # 
    # assert w.respond_to?(:header)
    # assert w.respond_to?(:footer)
    # assert w.respond_to?(:section_start)
    # assert w.respond_to?(:section_end)
    # assert w.respond_to?(:entry)
    # assert w.respond_to?(:result)
  end
  
end
