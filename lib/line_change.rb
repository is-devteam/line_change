require 'yaml'
require "line_change/version"
require "line_change/configuration"
require "line_change/deploy"

module LineChange
  DEFAULT_CONFIG = 'config/line_change.yml'.freeze

  def self.config_path
    @config_path ||= ENV['LINE_CHANGE_CONFIG'] || File.expand_path(DEFAULT_CONFIG)
  end

  def self.configuration
    @configuration ||= Configuration.new(YAML.load(open(config_path).read))
  end

  def self.deploy(*args)
    puts args
  end
end

require "line_change/tasks"
