# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::SearchTest < Test::Unit::TestCase

  def sample_reference
    return Cheatorious::CheatSheet.compile("Simple VIM") do
      
        description "A simple VIM cheatsheet for tests"
        author      "Luis Cipriani"
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

  def test_empty_search
    # TODO tests
    assert true
  end
  
end
