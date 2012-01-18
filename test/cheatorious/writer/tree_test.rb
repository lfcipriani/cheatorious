# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Cheatorious::Writer::TreeTest < Test::Unit::TestCase

  def test_writer_duck_typing
    w = Cheatorious::Writer::Tree.new

    assert w.respond_to?(:header)
    assert w.respond_to?(:search_header)
    assert w.respond_to?(:footer)
    assert w.respond_to?(:section_start)
    assert w.respond_to?(:section_end)
    assert w.respond_to?(:entry)
    assert w.respond_to?(:result)
  end

end
