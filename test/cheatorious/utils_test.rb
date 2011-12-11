# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::UtilsTest < Test::Unit::TestCase

  def cheat_hash
    {
      "description" => "a description",
      :cheatsheet   => {
        :root => [
          ["Save File", ":w"],
          {"Files" => [
            ["Open file",":e"]
          ]}
        ],        
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

    assert_equal ":e", object_again[:cheatsheet][:root][1]["Files"][0][1]
  end

  def test_serialize_and_deserialize_with_base64
    base64ed     = Cheatorious::Utils.serialize(cheat_hash, :base64)
    object_again = Cheatorious::Utils.deserialize(base64ed, :base64)
    
    assert_equal ":e", object_again[:cheatsheet][:root][1]["Files"][0][1]
  end
  
  def test_serialization_type
    base64ed     = Cheatorious::Utils.serialize(cheat_hash, :base64)
    marshaled    = Cheatorious::Utils.serialize(cheat_hash)
    
    assert_equal :base64, Cheatorious::Utils.serialization_type(base64ed)
    assert_equal :bytes , Cheatorious::Utils.serialization_type(marshaled)
  end
end
