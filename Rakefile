require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => "spec:all"

namespace :spec do
  %w(
    default
    installer
    config_with_path
  ).each do |config_file|
    desc "Run Tests against config: #{config_file}.yml"
    task config_file do
      sh "LINE_CHANGE_CONFIG=spec/support/config/#{config_file}.yml bundle exec rake spec"
    end
  end

  desc "Run Tests against all configs"
  task :all do
    %w(
      default
      installer
      config_with_path
    ).each do |config_file|
      sh "LINE_CHANGE_CONFIG=spec/support/config/#{config_file}.yml bundle exec rake spec"
    end
  end
end

