require 'thor'

module Cheatorious
  module DslExecutor
    def self.cheatsheet_for(name, &block)
      Cheatorious::CheatSheet.compile(name, @output, &block)
    end
  end
  
  class CLI < Thor
    include Thor::Actions
    
    desc "list", "lists the available cheatsheets. See 'import' command."
    def list
      ensure_workspace_exist
      puts (cheatsheet_list.empty? ? "You don't have imported cheatsheets. See 'import' command." : "You have #{cheatsheet_list.size} cheatsheet(s):")
      puts cheatsheet_list.join("\n")
    end
    
    desc "import FILE", "import a cheatsheet description FILE.\nCheck https://github.com/lfcipriani/cheatorious to learn how to create your own cheatsheets."
    def import(file)
      ensure_workspace_exist
      name = File.basename(file, ".rb")
      return if cheatsheet_list.include?(name) && 
                !yes?("Do you want to override the existent #{name} cheatsheet? (y/n)")
      if File.exist?(file)
        source = File.read(file)
        bytes = DslExecutor.module_eval("@output = :bytes\n"+source)
        File.open(File.join(workspace_path, "compiled", name), 'w') {|f| f.write(bytes) }
        File.open(File.join(workspace_path, "originals", name + ".rb"), 'w') {|f| f.write(source) }
        puts "Cheatsheet imported successfuly! Try 'cheatorious view #{name}'\nThe original cheatsheet file was copied to #{File.join(workspace_path, "originals", name + ".rb")}"
      else
        puts "The specified file doesn't exist: #{file}"
      end
    end
    
    desc "view CHEATSHEET [OPTIONS]", "view a CHEATSHEET.\nThe CHEATSHEET variable could be a name (for imported cheatsheets) or a file that describes a cheatsheet."
    method_option :writer, :aliases => "-w", :type => :string, :desc => "writer to use for the output. If not set, uses the default."
    def view(cheatsheet)
      invoke :search
    end
    
    desc "search CHEATSHEET [KEYWORD] [OPTIONS]", "search for KEYWORD in CHEATSHEET entries only.\nThe CHEATSHEET variable could be a name (for imported cheatsheets) or a file that describes a cheatsheet.\nOmit KEYWORD to view the full cheatsheet."
    method_option :section, :aliases => "-s", :type => :boolean, :desc => "matches KEYWORD only on section names, returning all entries and sections inside it."
    method_option :reverse, :aliases => "-r", :type => :boolean, :desc => "reverse means to search only the values of a cheatsheet (and not entries, as usual). For example, search by shortcuts."
    method_option :sensitive, :aliases => "-S", :type => :boolean, :desc => "case sensitive search (insensitive is default)."
    method_option :writer, :aliases => "-w", :type => :string, :desc => "writer to use for the output. If not set, uses the default."
    def search(cheatsheet, keyword = "")
      ensure_workspace_exist
      writer = options["writer"] ? writer_for(options["writer"]) : default_writer
      model = nil
      if cheatsheet_list.include?(cheatsheet)
        model = File.read(File.join(workspace_path, "compiled", cheatsheet))
      elsif File.exist?(cheatsheet)
        model = DslExecutor.module_eval("@output = nil\n" + File.read(cheatsheet))
      end
      if model
        puts Cheatorious::Search.execute(model, keyword, writer, options.dup)
      else
        puts "Invalid cheatsheet name or file name: #{cheatsheet}"
      end
    end

    desc "writers [OPTIONS]", "lists the available writers or set a default"
    method_option :default, :aliases => "-d", :type => :string, :desc => "set a default writer for next searches."
    def writers
      ensure_workspace_exist
      if options["default"]
        if Cheatorious::Writer.constants.map {|c| c.to_s}.include?(options["default"])
          config = YAML.load(File.open(File.join(workspace_path, "config")))
          config["default_writer"] = options["default"]
          File.open(File.join(workspace_path, "config"), "w") {|f| f.write(config.to_yaml) }
          puts "The default writer now is #{options["default"]}"
        else
          puts "Invalid writer name, use 'cheatorious writers' to choose one from the available."
        end
      else
        puts "The following writers are available:\n"
        dw = default_writer.to_s
        puts Cheatorious::Writer.constants.map {|w| (dw.end_with?(w.to_s) ? w.to_s + " (default)" : w.to_s) }.join("\n")
        puts "\nUse -d option to set a default writer."
      end
    end
    
    desc "alias NAME CHEATSHEET", "return a shell alias command with NAME for easy access to searching a CHEATSHEET.\nThe CHEATSHEET variable must be an imported cheatsheet.\nExample: cheatorious alias svim simple_vim >> ~/.bashrc\n         next time just use: svim KEYWORD [OPTIONS]"
    def alias(name, cheatsheet)
      ensure_workspace_exist
      if cheatsheet_list.include?(cheatsheet)
        puts "alias #{name}='cheatorious search #{cheatsheet}'"
      else
        puts "Invalid cheatsheet name: #{cheatsheet}"
      end
    end
    
  private

    def cheatsheet_list
      Dir[File.join(workspace_path, "compiled", "*")].map {|c| File.basename(c)}
    end

    def writer_for(constant)
      Cheatorious::Writer.const_get(constant)
    end

    def default_writer
      writer_for(YAML.load(File.open(File.join(workspace_path, "config")))["default_writer"])
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
      @workspace ||= File.join(Dir.home, ".cheatorious")
    end
  end
end