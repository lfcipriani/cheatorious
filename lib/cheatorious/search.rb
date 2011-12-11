module Cheatorious
  class Search
    
    class << self
      def execute(cheat_model, query = "", writer = Writer::Text, options = {})
        s = self.new(cheat_model)
        s.execute(query, writer, options)
      end
    end
    
    def initialize(cheat_model)
      cheat_model  = Utils.deserialize(cheat_model, Utils.serialization_type(cheat_model)) if cheat_model.kind_of?(String)
      @cheat_model = cheat_model
    end
    
    def execute(query = "", writer = Writer::Text, options = {})
      options[:print] = query.empty? ? :full : :partial
      w = writer.new(@cheat_model[:info])
      
      w.header if print_full?(options)
      
      depth_search(query, @cheat_model[:cheatsheet][:root], w, options)
      
      w.footer if print_full?(options)
      
      return w.result
    end
    
  private
  
    def depth_search(query, section, writer, options)
      section.each do |item|
        if item.kind_of?(Array) #entry
          name = item.shift
          writer.entry(name, *item)
        elsif item.kind_of?(Hash) #section
          name = item.keys.first
          writer.section_start(name)
          depth_search(query, item[name], writer, options)
          writer.section_end
        end
      end
    end
  
    def print_full?(options)
      options[:print] == :full
    end
  
  end
end
