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
      options.delete("reverse") if options["section"] && options["reverse"]
      
      # Filtering
      filtered = @cheat_model[:cheatsheet][:root].dup
      unless print_full?(query)
        filtered, results_count = depth_search(query, filtered, options)
      end
      
      # Writing
      w = writer.new
      print_full?(query) ? w.header(info[:name], info[:author], info[:version], info[:description]) : w.search_header(query, results_count, options)
      write_contents(filtered, w, options)
      w.footer if print_full?(query)
      
      return w.result
    end
    
  private
  
    def depth_search(query, section, options)
      match_count = 0
      
      result = section.select do |item|
        
        if item.kind_of?(Array) #entry
          unless options["section"]
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
          else
            false
          end
          
        elsif item.kind_of?(Hash) #section
          name = item.keys.first
          if options["section"] && match?(query, name, options["sensitive"])
            count = 1
          else
            item[name], count = depth_search(query, item[name], options)
          end
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
  
    def print_full?(query)
      query.empty?
    end
  
  end
end
