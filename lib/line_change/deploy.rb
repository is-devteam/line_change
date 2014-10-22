require 'line_change/connection'

module LineChange
  class Deploy
    attr_reader :id, :path

    def initialize(id, path)
      @id, @path = id, path
    end

    def start
      print "Uploading #{most_recent_modified_file_path} to Hockeyapp... "

      connection.upload(most_recent_modified_file_path, id).tap do |response|
        puts "Done!" "\n\n"
        puts "Response from Hockeyapp:"

        response.body.each do |key, value|
          puts "#{' ' * 4}" "#{key.ljust(19)}: #{value}"
        end
      end
    end

    private

    def most_recent_modified_file_path
      @most_recent_modified_file_path ||= begin
        file = Dir[path].map{|file_path| File.open(file_path) }.sort_by(&:mtime).last

        if file
          file.path
        else
          raise FileNotFound, "No such file or directory: #{path}"
        end
      end
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
