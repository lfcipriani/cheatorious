module Cheatorious
  class CheatSheet
    
    class << self
      def compile(name, output = nil, &block)
        c = self.new(name, &block)
        c.compile!(output)
      end
    end
    
    attr_reader :name
    
    def initialize(name, &block)
      @name       = name
      @block      = block
      @keys       = {}
      @cheat_hash = {
        :info       => { :name => name },
        :cheatsheet => {
          :root    => []
        }
      }
      @current_section = @cheat_hash[:cheatsheet][:root]
      @stack           = []
      @separator       = ""
    end
    
    def compile!(output = nil)
      self.instance_eval(&@block)
      return output ? Utils.serialize(@cheat_hash, output) : @cheat_hash
    end
    
    def description(info) 
      root[:info][:description] = info
    end
    
    def version(numbers)
      root[:info][:version] = numbers.to_s
    end
    
    def author(*args)
      root[:info][:author] = args
    end
    
    def key_separator(separator)
      @separator = separator
    end
    
    def key(identifier, value)
      @keys[identifier] = value
    end
    
    def section(name, &block)
      parent_section = @current_section
      
      new_section = { name => [] }
      @current_section = new_section[name]
      
      @stack.push(name)
      self.instance_eval(&block)
      @stack.pop
      
      @current_section = parent_section
      @current_section << new_section
    end
    
    def __(name, *values) 
      new_entry = [name]
      
      values.each do |v|
        new_entry << v
      end
      
      @current_section << new_entry
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
