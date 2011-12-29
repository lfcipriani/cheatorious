# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class Cheatorious::CliTest < Test::Unit::TestCase

  def setup
    FileUtils.cp(example_path + "/simple_vim.rb", example_path + "/simple_vim_test.rb")
  end

  def teardown
    FileUtils.rm_rf(File.expand_path(File.join(Dir.home, ".cheatorious")))
    FileUtils.rm(example_path + "/simple_vim_test.rb")
  end
  
  def test_list
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
      Cheatorious::CLI.start(["list"])
    end

    assert_not_nil out.string.index("You have 2 cheatsheet(s)")
    assert_not_nil out.string.index("simple_vim_test")
  end
  
  def test_import
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
    end

    assert_not_nil out.string.index("Cheatsheet imported successfuly!")
    assert File.exist?(File.join(Dir.home, ".cheatorious", "compiled", "simple_vim_test"))
    assert File.exist?(File.join(Dir.home, ".cheatorious", "originals", "simple_vim_test.rb"))
  end
  
  def test_import_wrong_file
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_wrong.rb"])
    end

    assert_not_nil out.string.index("The specified file doesn't exist")
  end
  
  def test_view
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
      Cheatorious::CLI.start(["view", "simple_vim_test"])
    end

    assert_not_nil out.string.index("^ E")
  end
  
  def test_search_on_file
    out = capture_stdout do
      Cheatorious::CLI.start(["search", example_path + "/simple_vim_test.rb", "scroll line up"])
    end

    assert_not_nil out.string.index("^ E")
  end
  
  def test_search_on_previously_imported_cheatsheet
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
      Cheatorious::CLI.start(["search", "simple_vim_test", "scroll line up"])
    end

    assert_not_nil out.string.index("^ E")
  end
  
  def test_search_with_another_writer
    load example_path + "/writer_sample.rb"
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
      Cheatorious::CLI.start(["search", "simple_vim_test", "scroll line up", "-w=WriterSample"])
    end

    assert_not_nil out.string.index("^ E")
  end
  
  def test_writers
    load example_path + "/writer_sample.rb"
    out = capture_stdout do
      Cheatorious::CLI.start(["writers"])
    end

    assert_not_nil out.string.index("Text (default)")
    assert_not_nil out.string.index("WriterSample")
  end
  
  def test_writers_setting_another_writer_as_default
    load example_path + "/writer_sample.rb"
    out = capture_stdout do
      Cheatorious::CLI.start(["writers", "-d=WriterSample"])
      Cheatorious::CLI.start(["writers"])
    end

    assert_not_nil out.string.index("The default writer now is WriterSample")
    assert_not_nil out.string.index("Text")
    assert_not_nil out.string.index("WriterSample (default)")
  end

  def test_writers_setting_wrong_writer_as_default
    load example_path + "/writer_sample.rb"
    out = capture_stdout do
      Cheatorious::CLI.start(["writers", "-d=WriterSampleWrong"])
      Cheatorious::CLI.start(["writers"])
    end

    assert_not_nil out.string.index("Invalid writer name, use 'cheatorious writers'")
  end
  
  def test_alias
    out = capture_stdout do
      Cheatorious::CLI.start(["import", example_path + "/simple_vim_test.rb"])
      Cheatorious::CLI.start(["alias", "svim", "simple_vim_test"])
    end

    assert_not_nil out.string.index("alias svim='cheatorious search simple_vim_test'")
  end
  
private
  
  def example_path
    File.expand_path(File.dirname(__FILE__) + '/../../examples')
  end
end
