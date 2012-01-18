# encoding: UTF-8
require "hirb"

module Cheatorious
  module Writer
    class Tree
      def initialize
        @section_stack = []
        @result        = ""
        @header_footer = []
        @tree          = []
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
        @header_footer << @result
        @add_empty_line = true
        @result = ""
      end

      def search_header(query, results_count, options)
        @query = query
        @options = options
        search_type = options.keys.join(", ")
        search_type += " " if search_type.size > 0
        line "Your #{search_type}search for '#{query.dup.foreground(@color)}' returned #{results_count} #{results_count > 1 ? "results" : "result"}:" if results_count != 0
        line "Your #{search_type}search for '#{query.dup.foreground(@color)}' doesn't returned any result. Try with another keyword." if results_count == 0
        line
        @header_footer << @result
        @add_empty_line = true
        @result = ""
      end

      def footer
        line
        line "-" * 80
        line "generated by Cheatorious (https://github.com/lfcipriani/cheatorious)"
        @header_footer << @result
        @result = nil
      end

      def section_start(section)
        section = paint(section,@query) if @query && @options['section']
        @tree << [@section_stack.size, "#".foreground(:red) + " " + section]
        @section_stack.push(section)
      end

      def section_end
        @section_stack.pop
      end

      def entry(name, *values)
        value_text = values.join(", ")
        if @options['reverse']
          value_text = paint(value_text,@query) if @query
        elsif !@options['section']
          name = paint(name,@query) if @query
        end
        indent = @section_stack.size == 0 ? 0 : @section_stack.size+1
        @tree << [indent, "=>".foreground(:blue) + " " + name]
        value_text.split(", ").each do |v|
          @tree << [indent+1, v]
        end
      end

      def result
        @result = @header_footer[0]
        @result += Hirb::Helpers::Tree.render(@tree, :type => :directory)
        @result += @header_footer[1] || ""
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

      def paint(string, query)
        string.gsub(regex_for(query)) {|q| q.foreground(@color)}
      end

      def regex_for(query)
        Regexp.new(Regexp.escape(query), (@options['sensitive'] ? 0 : Regexp::IGNORECASE))
      end
    end
  end
end
