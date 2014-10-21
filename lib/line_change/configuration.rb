module LineChange
  class Configuration
    attr_reader :apps, :api_key

    def initialize(config)
      @apps = config['apps'] || config[:apps]
      @api_key = config['api_key'] || config[:api_key]
    end
  end
end
