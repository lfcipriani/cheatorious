# encoding: UTF-8

module Cheatorious
  module Writer
    class Alfred
      def initialize
        @section_stack = []
        @result        = ""
        @query         = nil
        @options       = {}
      end

      def header(name, author = "", version = "", description = "")
        line "<?xml version=\"1.0\"?>"
        line "<items>"
      end

      def search_header(query, results_count, options)
        @query = query
        @options = options
        line "<?xml version=\"1.0\"?>"
        line "<items>"
      end

      def footer
        line "</items>"
      end

      def section_start(section)
        @section_stack.push(section)
      end

      def section_end
        @section_stack.pop
      end

      def entry(name, *values)
        value_text = values.join(", ")
        if @options['reverse']
          line "  <item arg=\"#{name}\">"
          line "    <subtitle>#{value_text}</subtitle>"
          line "    <title>#{@section_stack.join(" > ")} > #{name}</title>"
        else
          line "  <item arg=\"#{value_text}\">"
          line "    <title>#{value_text}</title>"
          line "    <subtitle>#{@section_stack.join(" > ")} > #{name}</subtitle>"
        end
        line "    <icon></icon>"
        line "  </item>"
      end

      def result
        @result
      end

    private

      def line(str = "")
        if str.empty?
          if @add_empty_line
            @result += str + "\n"
            @add_empty_line = false
          end
        else
          @result += str + "\n"
          @add_empty_line = true
        end
      end

      def indentation(char)
        char * 3 * @section_stack.size
      end

    end
  end
end
