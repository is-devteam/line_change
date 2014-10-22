require 'line_change/connection'

module LineChange
  class Deploy
    attr_reader :id, :path

    def initialize(id, path)
      @id, @path = id, path
    end

    def start
      print "Uploading #{path} to Hockeyapp... "

      connection.upload(path, id).tap do |response|
        puts "Done!" "\n\n"
        puts "Response from Hockeyapp:"

        response.body.each do |key, value|
          puts "#{' ' * 4}" "#{key.ljust(19)}: #{value}"
        end
      end
    end

    private

    def connection
      @connection ||= Connection.new
    end
  end
end
