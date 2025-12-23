# frozen_string_literal: true

require "rake/testtask"
require "rubocop/rake_task"
require "bundler/gem_tasks"

# Default task: run tests
task default: :test

# Minitest task
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = true
  t.verbose = true
end

# RuboCop task
RuboCop::RakeTask.new(:rubocop)

# Convenience task to run both linting and tests
desc "Run all checks (RuboCop + Tests)"
task check: %i[rubocop test]

desc "Open an IRB console with the gem loaded"
task :console do
  require "irb"
  require "active_support/all"
  require_relative "lib/rails_outofband_keys"
  ARGV.clear
  IRB.start
end
