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
      
      filtered = @cheat_model[:cheatsheet][:root].dup
      unless print_full?(options)
        filtered, results_count = depth_search(query, filtered, options)
      end
      
      w = writer.new(@cheat_model[:info])
      print_full?(options) ? w.header : w.search_header(query, results_count, "")
      write_contents(filtered, w, options)
      w.footer if print_full?(options)
      
      return w.result
    end
    
  private
  
    def depth_search(query, section, options)
      match_count = 0
      result = section.select do |item|
        if item.kind_of?(Array) #entry
          name = item[0]
          result = match?(query, name)
          match_count += 1 if result
          result
        elsif item.kind_of?(Hash) #section
          name = item.keys.first
          item[name], count = depth_search(query, item[name], options)
          match_count += count
          item[name].size > 0
        else
          false
        end
      end
      return result, match_count
    end
  
    def write_contents(section, writer, options)
      section.each do |item|
        if item.kind_of?(Array) #entry
          name = item.shift
          writer.entry(name, *item)
        elsif item.kind_of?(Hash) #section
          name = item.keys.first
          writer.section_start(name)
          write_contents(item[name], writer, options)
          writer.section_end
        end
      end
    end
  
    def match?(query, name)
      not name.downcase.index(query.downcase).nil?
    end
  
    def print_full?(options)
      options[:print] == :full
    end
  
  end
end
