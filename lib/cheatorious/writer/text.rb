module Cheatorious
  module Writer    
    class Text
      def initialize(cheatsheet_info = {})
        @info          = cheatsheet_info
        @section_stack = []
        @result        = ""
      end
      
      def header
        line
        line "-" * 80
        line "#{@info[:name]} (#{@info[:version]})"
        line
        line "Author     : #{@info[:author][0]} (#{@info[:author][1]})"
        line "Description: #{@info[:description]}"
        line "-" * 80
        line
      end
      
      def search_header(query, results_count, query_type)
        line
        line "Your search for '#{query}' returned #{results_count} #{results_count > 1 ? "entries" : "entry"}:" if results_count != 0
        line "Your search for '#{query}' doesn't returned any entry. Try with another keyword." if results_count == 0
        line
      end
      
      def footer
        line
        line "-" * 80
        line "generated by Cheatorious (https://github.com/lfcipriani/cheatorious)"
      end
      
      def section_start(section)
        @section_stack.push(section)
        line indentation("-") + " #{section}"
      end
      
      def section_end
        @section_stack.pop
      end
      
      def entry(name, *values)
        e = "#{indentation(" ")} - #{name}: "
        e << values.join(", ")
        line e
      end
      
      def result
        @result
      end
      
    private
    
      def line(str = "")
        @result += str + "\n"
      end
      
      def indentation(char)
        char * 2 * @section_stack.size
      end
    end
  end
end