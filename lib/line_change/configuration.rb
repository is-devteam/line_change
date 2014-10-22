module LineChange
  class Configuration
    attr_reader :api_key

    def initialize(config)
      @raw_apps = config['apps'] || config[:apps]
      @api_key = config['api_key'] || config[:api_key]
    end

    def apps
      @apps ||= Array(@raw_apps).map{|app_name, app_config| App.new(app_name, app_config) }
    end

    def self.exists?
      File.exist?(LineChange.config_path)
    end

    def self.create_config(config_dir, config_path)
      unless File.exist?(config_dir)
        FileUtils.mkdir_p(config_dir)
      end

      FileUtils.cp("#{__dir__}/templates/line_change.yml", config_path)
    end

    class App
      attr_reader :name
      alias env name

      def initialize(name, config)
        @name, @config = name.to_s, normalize(config)
      end

      def app_id
        @config[:app_id] || @config["app_id"]
      end

      def path
        @config[:path] || @config["path"]
      end

      private

      def normalize(config)
        if config.is_a?(Hash)
          config
        elsif config.is_a?(String) || config.is_a?(Symbol)
          {app_id: config.to_s}
        else
          raise 'Wrong config format: #{config}'
        end
      end
    end
  end
end
