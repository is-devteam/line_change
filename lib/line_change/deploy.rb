require 'line_change/connection'

module LineChange
  class Deploy
    def initialize(id, path)
      @id, @path = id, path
    end

    def start
      connection.upload(@path, @id)
    end

    private

    def connection
      @connection ||= Connection.new
    end
  end
end
