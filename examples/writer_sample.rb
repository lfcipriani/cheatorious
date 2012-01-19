module Cheatorious
  module Writer
    # This is an example of a Writer
    #
    # To implement your own Writer, just create a class inside
    # Cheatorious::Writer module and implement the interface
    # represented by the public methods below.
    class WriterSample
      def initialize
        @section_stack = []
        @result        = ""
        @query         = nil
        @options       = {}
        @color         = :yellow
        @add_empty_line = true
      end

      def header(name, author = "", version = "", description = "")
        line "-" * 80
        line "#{name} (#{version})"
        line
        line "Author     : #{author[0]} (#{author[1]})"
        line "Description: #{description}"
        line "-" * 80
        line
      end

      def search_header(query, results_count, options)
        @query = query
        @options = options
        search_type = (options.keys - ["writer"]).join(", ")
        search_type += " " if search_type.size > 0
        line "Your #{search_type}search for '#{query.dup.foreground(@color)}' returned #{results_count} #{results_count > 1 ? "results" : "result"}:" if results_count != 0
        line "Your #{search_type}search for '#{query.dup.foreground(@color)}' doesn't returned any result. Try with another keyword." if results_count == 0
        line
      end

      def footer
        line
        line "-" * 80
        line "generated by Cheatorious (https://github.com/lfcipriani/cheatorious)"
      end

      def section_start(section)
        @section_stack.push(section)
        section = paint(section,@query) if @query && @options['section']
        line
        line indentation(" ") + "#".foreground(:red) + " #{section} "+ "#".foreground(:red)
      end

      def section_end
        @section_stack.pop
        line
      end

      def entry(name, *values)
        value_text = values.join(", ")
        if @options['reverse']
          value_text = paint(value_text,@query) if @query
        elsif !@options['section']
          name = paint(name,@query) if @query
        end
        e = "#{indentation(" ")}   #{name} " + "=> ".foreground(:blue)
        e << value_text
        line e
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

      def paint(string, query)
        string.gsub(regex_for(query)) {|q| q.foreground(@color)}
      end

      def regex_for(query)
        Regexp.new(Regexp.escape(query), (@options['sensitive'] ? 0 : Regexp::IGNORECASE))
      end
    end
  end
end
