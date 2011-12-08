# encoding: UTF-8
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*.rb']
  t.verbose = true
end

desc 'Load the gem environment'
task :environment do
  require File.expand_path(File.dirname(__FILE__) + '/lib/cheatorious.rb')
end

# To load rake tasks on lib/task folder
# load 'lib/tasks/task_sample.rake'

task :default => :test
