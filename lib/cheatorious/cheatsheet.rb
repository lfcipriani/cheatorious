module Cheatorious
  class CheatSheet
    
    class << self
      def compile(name, &block)
        c = self.new(name, &block)
        c.compile!
      end
    end
    
    attr_reader :name
    
    def initialize(name, &block)
      @name       = name
      @block      = block
      @keys       = {}
      @cheat_hash = {
        :cheatsheet => {
          :root => {}
        }
      }
      @current_section = @cheat_hash[:cheatsheet][:root]
      @separator = ""
    end
    
    def compile!
      self.instance_eval(&@block)
      return @cheat_hash
    end
    
    def description(info) 
      root["description"] = info
    end
    
    def version(numbers)
      root["version"] = numbers.to_s
    end
    
    def author(*args)
      root["author"] = args
    end
    
    def key_separator(separator)
      @separator = separator
    end
    
    def key(identifier, value)
      @keys[identifier] = value
    end
    
    def section(name, &block)
      @current_section[:sections] = {} unless @current_section.key?(:sections)
      @current_section[:sections][name] = {} unless @current_section[:sections].key?(name)
      parent_section = @current_section
      @current_section = @current_section[:sections][name]
      
      self.instance_eval(&block)
      
      @current_section = parent_section
    end
    
    def __(name, *values)
      @current_section[:entries] = {} unless @current_section.key?(:entries)
      @current_section[:entries][name] = [] unless @current_section[:entries].key?(name)
      values.each do |v|
        @current_section[:entries][name] << v
      end
    end
    
    def method_missing(method, *args)
      method_name = method.to_s

      if method_name.start_with?("_")
        method_name = method_name[/_(.*)/,1].to_sym
        return @keys[method_name] + (args[0].nil? ? "" : @separator + args[0].to_s) if @keys.key?(method_name)
      end
      
      super
    end
    
  private
  
    def root
      @cheat_hash
    end

    def sheet
      @cheat_hash[:cheatsheet]
    end

  end
end

# hash = {
#   "description" => "bla",
#   "cheatsheet" => {
#     :root => {
#             :entries => { "Save File" => [":w"] },
#             :sections => { "files" => {} }
#             }
#   }
# }