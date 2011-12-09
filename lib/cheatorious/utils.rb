module Cheatorious
  class Utils
    require "base64"
    
    def self.serialize(object, to = nil)
      data = Marshal.dump(object)
      data = Base64.encode64(data) if to == :base64
      return data
    end
    
    def self.deserialize(data, from = nil)
      data   = Base64.decode64(data) if from == :base64
      object = Marshal.load(data)
      return object
    end
  end
end
