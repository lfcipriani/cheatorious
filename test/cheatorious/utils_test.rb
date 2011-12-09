# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::UtilsTest < Test::Unit::TestCase

  def cheat_hash
    {
      "description" => "a description",
      :cheatsheet   => {
        :root => {
          :entries  => { "Save File" => [":w"] },
          :sections => { 
            "Files" => {
              :entries  => { "Open file" => [":e"] },
              :sections => {}
            } 
          }
        },
        :reverse => {
           ":w" => [{:name => "Save file", :section => []}],
           ":e" => [{:name => "Open File", :section => ["Files"]}]
        }
      }
    }
  end

  def test_serialize_and_deserialize_with_marshal
    marshaled    = Cheatorious::Utils.serialize(cheat_hash)
    object_again = Cheatorious::Utils.deserialize(marshaled)

    assert_equal ":e", object_again[:cheatsheet][:root][:sections]["Files"][:entries]["Open file"].first
  end

  def test_serialize_and_deserialize_with_base64
    base64ed     = Cheatorious::Utils.serialize(cheat_hash, :base64)
    object_again = Cheatorious::Utils.deserialize(base64ed, :base64)
    
    assert_equal ":e", object_again[:cheatsheet][:root][:sections]["Files"][:entries]["Open file"].first
  end
  
end
