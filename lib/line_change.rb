require 'yaml'
require "line_change/version"

module LineChange
  @@config_path = ENV['HOCKEYAPP_CONFIG'] || File.expand_path('config/hockeyapp.yml')

  def self.config_path
    @@config_path
  end

  def self.configuration
    @configuration ||= YAML.load(open(config_path).read)
  end

  def self.deploy(*args)
    puts args
  end
end

require "line_change/tasks"
