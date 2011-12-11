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
    
    assert_equal "A personal VIM reference"                     , c[:info][:description]
    assert_equal ["Luis Cipriani", "URL of the author or email"], c[:info][:author]
    assert_equal "1.0.0"                                        , c[:info][:version]   
  end
  
  def test_meta_information_is_nil_otherwise
    c = Cheatorious::CheatSheet.compile("VIM") do
      # stuff
    end
    
    assert_nil c[:info][:description]
    assert_nil c[:info][:author]
    assert_nil c[:info][:version]   
  end

  def test_cheatsheet_simple_entry
    c = Cheatorious::CheatSheet.compile("VIM") do
      __ "Save file", ":w"
    end
    
    assert_equal "Save file", c[:cheatsheet][:root].first[0]
    assert_equal ":w"       , c[:cheatsheet][:root].first[1]
  end
  
  def test_cheatsheet_simple_entry_with_several_options
    c = Cheatorious::CheatSheet.compile("VIM") do
      __ "Go to insertion mode", "i", "I", "a"
    end
    
    assert_equal "i", c[:cheatsheet][:root].first[1]
    assert_equal "I", c[:cheatsheet][:root].first[2]
    assert_equal "a", c[:cheatsheet][:root].first[3]
  end
  
  def test_cheatsheet_section
    c = Cheatorious::CheatSheet.compile("VIM") do
      section "Files" do
        __ "Save file", ":w"
        __ "Open file", ":e"
      end
    end
    
    assert_equal ":w", c[:cheatsheet][:root].first["Files"][0][1]
    assert_equal ":e", c[:cheatsheet][:root].first["Files"][1][1]
  end
  
  def test_cheatsheet_section_inside_section
    c = Cheatorious::CheatSheet.compile("VIM") do
      section "Files" do
        __ "Open file", ":e"
        
        section "Saving" do
          __ "Save file", ":w"
        end
      end
    end
    
    assert_equal ":e", c[:cheatsheet][:root].first["Files"][0][1]
    assert_equal ":w", c[:cheatsheet][:root].first["Files"][1]["Saving"][0][1]
  end

  def test_cheatsheet_keyboard_key_configurations
    c = Cheatorious::CheatSheet.compile("VIM") do
      key :control, "^"
      
      __ "Scroll line up", _control("E")
    end
    
    assert_equal "^E", c[:cheatsheet][:root].first[1]
  end
  
  def test_cheatsheet_keyboard_key_multiple_configurations
    c = Cheatorious::CheatSheet.compile("VIM") do
      key :control, "^"
      
      __ "Scroll line up, down", _control("E"), (_control "Y")
    end
    
    assert_equal "^E", c[:cheatsheet][:root].first[1]
    assert_equal "^Y", c[:cheatsheet][:root].first[2]
  end
  
  def test_cheatsheet_keyboard_key_separators
    c = Cheatorious::CheatSheet.compile("VIM") do
      key_separator "+"
      
      key :control, "^"
      key :shift  , "SHIFT"
      key :alt    , "ALT"
      
      __ "Do something crazy"   , (_control _shift _alt "A")
      __ "Just pressing control", _control
    end
    
    assert_equal "^+SHIFT+ALT+A", c[:cheatsheet][:root][0][1]
    assert_equal "^"            , c[:cheatsheet][:root][1][1]
  end
  
  def test_cheatsheet_reverse_index
    c = Cheatorious::CheatSheet.compile("VIM") do
      __ "Create asset", ":w"
      
      section "Files" do
        __ "Open file", ":e"
        
        section "Saving" do
          __ "Save file", ":w"
        end
      end
    end
    
    assert_equal "Create asset"     , c[:cheatsheet][:reverse][":w"][0][:name]
    assert_equal []                 , c[:cheatsheet][:reverse][":w"][0][:section]
    assert_equal "Save file"        , c[:cheatsheet][:reverse][":w"][1][:name]
    assert_equal ["Files", "Saving"], c[:cheatsheet][:reverse][":w"][1][:section]
    assert_equal "Open file"        , c[:cheatsheet][:reverse][":e"][0][:name]
    assert_equal ["Files"]          , c[:cheatsheet][:reverse][":e"][0][:section]
  end

  def test_compile_support_serialization_to_bytes
    c = Cheatorious::CheatSheet.compile("VIM", :bytes) do
      __ "Create asset", ":w"
      
      section "Files" do
        __ "Open file", ":e"
        
        section "Saving" do
          __ "Save file", ":w"
        end
      end
    end
    obj = Cheatorious::Utils.deserialize(c)
    
    assert_equal "Create asset", obj[:cheatsheet][:reverse][":w"][0][:name]
  end
  
  def test_compile_support_serialization_to_base64
    c = Cheatorious::CheatSheet.compile("VIM", :base64) do
      __ "Create asset", ":w"
      
      section "Files" do
        __ "Open file", ":e"
        
        section "Saving" do
          __ "Save file", ":w"
        end
      end
    end
    obj = Cheatorious::Utils.deserialize(c, :base64)
    
    assert_equal "Create asset", obj[:cheatsheet][:reverse][":w"][0][:name]
  end
end
