module Cheatorious
  class CheatSheet
    
    class << self
      def compile(name, &block)
        c = self.new(name, &block)
        c.parse!
      end
    end
    
    attr_reader :name
    
    def initialize(name, &block)
      @name = name
      @block = block
      @cheat_hash = {
        :cheatsheet => {
          :root => {}
        }
      }
      @current_section = @cheat_hash[:cheatsheet][:root]
    end
    
    def parse!
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
    
    def section(name, &block)
      @current_section[:sections] = {} unless @current_section.key?(:sections)
      @current_section[:sections][name] = {} unless @current_section[:sections].key?(name)
      previous_section = @current_section
      @current_section = @current_section[:sections][name]
      
      self.instance_eval(&block)
      
      @current_section = previous_section
    end
    
    def ___(name, value = nil, &block)
      @current_section[:entries] = {} unless @current_section.key?(:entries)
      @current_section[:entries][name] = [] unless @current_section[:entries].key?(name)
      @current_section[:entries][name] << value if value
      if block_given?
        @current_entry = @current_section[:entries][name]
        self.instance_eval(&block)
      end
    end
    
    def __(value)
      @current_entry << value
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