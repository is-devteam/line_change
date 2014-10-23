require 'yaml'
require "line_change/version"
require "line_change/errors"
require "line_change/configuration"
require "line_change/deploy"

module LineChange
  DEFAULT_CONFIG = 'config/line_change.yml'.freeze

  def self.config_path
    @config_path ||= ENV['LINE_CHANGE_CONFIG'] || File.expand_path(DEFAULT_CONFIG)
  end

  def self.config_dir
    @config_dir ||= File.dirname(config_path)
  end

  def self.configuration
    @configuration ||= Configuration.new(YAML.load(open(config_path).read))
  end

  def self.deploy(app_id, apk_path)
    Deploy.new(app_id, apk_path).start
  end

  def self.install
    if Configuration.exists?
      puts "You already have a config file in #{config_path}!"
    else
      puts "Generating a new config file: #{config_path}"
      Configuration.create_config(config_dir, config_path)
    end
  end
end
