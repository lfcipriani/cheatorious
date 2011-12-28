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
      info = @cheat_model[:info]
      
      filtered = @cheat_model[:cheatsheet][:root].dup
      unless print_full?(query, options)
        filtered, results_count = depth_search(query, filtered, options)
      end
      
      w = writer.new
      print_full?(query, options) ? w.header(info[:name], info[:author], info[:version], info[:description]) : w.search_header(query, results_count, "")
      write_contents(filtered, w, options)
      w.footer if print_full?(query, options)
      
      return w.result
    end
    
  private
  
    def depth_search(query, section, options)
      match_count = 0
      
      result = section.select do |item|
        
        if item.kind_of?(Array) #entry
          name = item[0]
          matched = false
          if options["reverse"]
            item[1..-1].each do |value|
              matched = match?(query, value, options["sensitive"])
              break if matched
            end
          else
            matched = match?(query, name, options["sensitive"])
          end
          match_count += 1 if matched
          matched
          
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
  
    def match?(query, name, sensitive)
      !(Regexp.new(Regexp.escape(query), (sensitive ? 0 : Regexp::IGNORECASE)) =~ name).nil?
    end
  
    def print_full?(query, options)
      query.empty? && !options["section"]
    end
  
  end
end
