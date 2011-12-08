# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::CheatSheetTest < Test::Unit::TestCase

  def test_cheatsheet_instantiation
    c = Cheatorious::CheatSheet.new("VIM") do
      # require a block
    end
    
    assert c.kind_of?(Cheatorious::CheatSheet)
    assert_equal "VIM", c.name
  end
  
  def test_support_of_cheatsheet_meta_information
    c = Cheatorious::CheatSheet.compile("VIM") do
      description "A personal VIM reference"
      author      "Luis Cipriani", "URL of the author or email"
      version     "1.0.0"
    end
    
    assert_equal "A personal VIM reference"                     , c["description"]
    assert_equal ["Luis Cipriani", "URL of the author or email"], c["author"]
    assert_equal "1.0.0"                                        , c["version"]   
  end
  
  def test_meta_information_is_nil_otherwise
    c = Cheatorious::CheatSheet.compile("VIM") do
      # stuff
    end
    
    assert_nil c["description"]
    assert_nil c["author"]
    assert_nil c["version"]   
  end

  def test_cheatsheet_simple_entry
    c = Cheatorious::CheatSheet.compile("VIM") do
      ___ "Save file", ":w"
    end
    
    assert_equal ":w", c[:cheatsheet][:root][:entries]["Save file"].first
  end
  
  def test_cheatsheet_simple_entry_with_several_options
    c = Cheatorious::CheatSheet.compile("VIM") do
      ___ "Go to insertion mode", "i", "I", "a"
    end
    
    assert_equal "i", c[:cheatsheet][:root][:entries]["Go to insertion mode"][0]
    assert_equal "I", c[:cheatsheet][:root][:entries]["Go to insertion mode"][1]
    assert_equal "a", c[:cheatsheet][:root][:entries]["Go to insertion mode"][2]
  end
  
  def test_cheatsheet_section
    c = Cheatorious::CheatSheet.compile("VIM") do
      section "Files" do
        ___ "Save file", ":w"
        ___ "Open file", ":e"
      end
    end
    
    assert_equal ":w", c[:cheatsheet][:root][:sections]["Files"][:entries]["Save file"].first
    assert_equal ":e", c[:cheatsheet][:root][:sections]["Files"][:entries]["Open file"].first
  end
  
  def test_cheatsheet_section_inside_section
    c = Cheatorious::CheatSheet.compile("VIM") do
      section "Files" do
        ___ "Open file", ":e"
        
        section "Saving" do
          ___ "Save file", ":w"
        end
      end
    end
    
    assert_equal ":w", c[:cheatsheet][:root][:sections]["Files"][:sections]["Saving"][:entries]["Save file"].first
    assert_equal ":e", c[:cheatsheet][:root][:sections]["Files"][:entries]["Open file"].first
  end

  def test_cheatsheet_keyboard_key_configurations
    c = Cheatorious::CheatSheet.compile("VIM") do
      key :control, "^"
      
      ___ "Scroll line up", _control("E")
    end
    
    assert_equal "^E", c[:cheatsheet][:root][:entries]["Scroll line up"].first
  end
  
  def test_cheatsheet_keyboard_key_multiple_configurations
    c = Cheatorious::CheatSheet.compile("VIM") do
      key :control, "^"
      
      ___ "Scroll line up, down", _control("E"), (_control "Y")
    end
    
    assert_equal "^E", c[:cheatsheet][:root][:entries]["Scroll line up, down"][0]
    assert_equal "^Y", c[:cheatsheet][:root][:entries]["Scroll line up, down"][1]
  end
  
  def test_cheatsheet_keyboard_key_separators
    c = Cheatorious::CheatSheet.compile("VIM") do
      key_separator "+"
      
      key :control, "^"
      key :shift  , "SHIFT"
      key :alt    , "ALT"
      
      ___ "Do something crazy"   , (_control _shift _alt "A")
      ___ "Just pressing control", _control
    end
    
    assert_equal "^+SHIFT+ALT+A", c[:cheatsheet][:root][:entries]["Do something crazy"][0]
    assert_equal "^"            , c[:cheatsheet][:root][:entries]["Just pressing control"][0]
  end
  
end
