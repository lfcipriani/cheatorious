# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::SearchTest < Test::Unit::TestCase

  def cheatsheet_model
    return Cheatorious::CheatSheet.compile("Simple VIM") do
      
        description "A simple VIM cheatsheet for tests"
        author      "Luis Cipriani", "github.com/lfcipriani"
        version     "1.0.0"
      
        key_separator " "
      
        key :control, "^"
        key :esc    , "<esc>"
        key :leader , ","

        __ "Enter insertion mode", "i"
        __ "Exit insertion mode" , _esc
      
        section "Basic Movement" do
            __ "character left, right, line up, line down", "h", "l", "k", "j"
            __ "word/token left, right"                   , "b", "w"
        end
      
        section "Scrolling" do
            __ "scroll line up, down", (_control "E"), (_control "Y")
            __ "scroll page up, down", (_control "F"), (_control "B")
        end
      
        section "Files" do
            __ "Open file", ":e"
        
            section "Saving" do
                __ "Save file", ":w"
            end
        end
      
    end
  end

  def test_empty_search_prints_full_cheatsheet
    result = Cheatorious::Search.execute(cheatsheet_model)

    assert_not_nil result.index("A simple VIM cheatsheet for tests")
    assert_not_nil result.index("Enter insertion mode")
    assert_not_nil result.index("Scrolling")
    assert_not_nil result.index("^ E")
  end

  def test_simple_keyword_search
    result = Cheatorious::Search.execute(cheatsheet_model, "scroll")
    
    assert_not_nil result.index("2 results")
    assert_nil result.index("Enter insertion mode")
    assert_not_nil result.index("Scrolling")
    assert_not_nil result.index("^ E")
    assert_not_nil result.index("^ F")
    assert_nil result.index("Open file")
    assert_nil result.index("Files")
  end  

  def test_simple_keyword_search_for_root_entry
    result = Cheatorious::Search.execute(cheatsheet_model, "exit insertion")
    
    assert_not_nil result.index("1 result")
    assert_not_nil result.index("Exit insertion mode")
    assert_nil result.index("Scrolling")
    assert_nil result.index("Files")
    assert_nil result.index("Saving")
  end

  def test_simple_keyword_search_from_the_deep
    result = Cheatorious::Search.execute(cheatsheet_model, "save")
    
    assert_not_nil result.index("1 result")
    assert_not_nil result.index("Save file")
    assert_nil result.index("Scrolling")
    assert_not_nil result.index("Files")
    assert_not_nil result.index("Saving")
  end

  def test_simple_keyword_search_from_the_deep
    result = Cheatorious::Search.execute(cheatsheet_model, "save")
    
    assert_not_nil result.index("1 result")
    assert_not_nil result.index("Save file")
    assert_nil result.index("Scrolling")
    assert_not_nil result.index("Files")
    assert_not_nil result.index("Saving")
  end

  def test_non_existant_keyword
    result = Cheatorious::Search.execute(cheatsheet_model, "buzzword")
    
    assert_not_nil result.index("Try with another keyword")
  end
  
  def test_section_keyword_matching_returning_entire_section
    result = Cheatorious::Search.execute(cheatsheet_model, "basic", Cheatorious::Writer::Text, "section" => true)

    assert_not_nil result.index("Basic Movement")
    assert_not_nil result.index("character left, right, line up, line down")
    assert_not_nil result.index("word/token left, right")
    assert_nil result.index("Enter insertion mode")
  end

  def test_deep_section_keyword_matching_returning_entire_section
    result = Cheatorious::Search.execute(cheatsheet_model, "saving", Cheatorious::Writer::Text, "section" => true)
    
    assert_not_nil result.index("Files")
    assert_not_nil result.index("Save file")
    assert_not_nil result.index(":w")
    assert_nil result.index("Open file")
  end
  
  def test_reverse_search
    result = Cheatorious::Search.execute(cheatsheet_model, "^ e", Cheatorious::Writer::Text, "reverse" => true)

    assert_not_nil result.index("scroll line up, down")
    assert_not_nil result.index("Scrolling")
    assert_nil result.index("scroll page up, down")
  end

  def test_reverse_search_sensitive
    result = Cheatorious::Search.execute(cheatsheet_model, "^ e", Cheatorious::Writer::Text, "reverse" => true, "sensitive" => true)

    assert_not_nil result.index("search for '^ e' doesn't returned any result")
  end
  
  def test_reverse_search_again
    result = Cheatorious::Search.execute(cheatsheet_model, "h", Cheatorious::Writer::Text, "reverse" => true)
    
    assert_not_nil result.index("character left, right, line up, line down")
    assert_nil result.index("word/token left, right")
  end
  
end
