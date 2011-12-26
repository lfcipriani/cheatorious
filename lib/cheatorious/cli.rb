require 'thor'

module Cheatorious
  module DslExecutor
    def self.cheatsheet_for(name, output = :bytes, &block)
      Cheatorious::CheatSheet.compile(name, output, &block)
    end
  end
  
  class CLI < Thor
    include Thor::Actions
    
    desc "list", "lists the available cheatsheets. See 'import' command"
    def list
      ensure_workspace_exist
      puts (cheatsheet_list.empty? ? "You don't have imported cheatsheets. See 'import' command." : "You have #{cheatsheet_list.size} cheatsheet(s):")
      puts cheatsheet_list.map {|c| File.basename(c)}.join("\n")
    end
    
    desc "import FILE NAME", "import a cheatsheet FILE with optional NAME specified"
    def import(file, name)
      ensure_workspace_exist
      if File.exist?(file)
        source = File.read(file)
        bytes = DslExecutor.module_eval(source)
        File.open(File.join(workspace_path, "compiled", name), 'w') {|f| f.write(bytes) }
        File.open(File.join(workspace_path, "originals", name), 'w') {|f| f.write(source) }
        puts "Cheatsheet imported successfuly! Try 'cheatorious view #{name}'"
      else
        puts "The specified file doesn't exist: #{file}"
      end
    end
    
    desc "view CHEATSHEET [OPTIONS]", "view a CHEATSHEET.\nThe CHEATSHEET variable could be a name or a file."
    method_option :writer, :aliases => "-w", :type => :string, :desc => "writer to use for the output"
    def view(cheatsheet)
    end
    
    desc "search CHEATSHEET [KEYWORD] [OPTIONS]", "view or search for KEYWORD in a CHEATSHEET\nThe CHEATSHEET variable could be a name or a file"
    method_option :section, :aliases => "-s", :type => :boolean, :desc => "matches keyword on section names, returning all entries inside it"
    method_option :reverse, :aliases => "-r", :type => :boolean, :desc => "matches values of cheatsheet, do reverse search"
    method_option :sensitive, :aliases => "-S", :type => :boolean, :desc => "case sensitive search"
    method_option :writer, :aliases => "-w", :type => :string, :desc => "writer to use for the output"
    def search(cheatsheet, keyword = "")
    end
    
  private

    def cheatsheet_list
      Dir[File.join(workspace_path, "compiled", "*")]
    end
    
    def ensure_workspace_exist
      unless File.directory?(workspace_path)
        Dir.mkdir(workspace_path)
      end
      unless File.exist?(File.join(workspace_path, "config"))
        create_file File.join(workspace_path, "config"), "default_writer: Text\n", :verbose => false
      end
      unless File.directory?(File.join(workspace_path, "compiled"))
        Dir.mkdir(File.join(workspace_path, "compiled"))
      end
      unless File.directory?(File.join(workspace_path, "originals"))
        Dir.mkdir(File.join(workspace_path, "originals"))
      end
    end
    
    def workspace_path
      File.join(Dir.home, ".cheatorious")
    end
  end
end