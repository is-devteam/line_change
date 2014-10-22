module LineChange
  class Error < StandardError; end

  # API errors
  class APIError < Error
    attr_reader :status, :headers, :body

    def initialize(args)
      @status, @headers, @body = args[:status], args[:headers], parse_json(args[:body])

      message =
        body['message'] ||
        (body['errors'] && convert_hash_to_message(body['errors'])) ||
        body

      super(message)
    end

    private

    def parse_json(body)
      JSON.parse(body.to_s)
    rescue JSON::ParserError
      body
    end

    def convert_hash_to_message(hash)
      hash.map{|_| _.join(' ').capitalize }.join('. ')
    end
  end

  class ServerError < APIError; end
  class ClientError < APIError; end

  # 500
  class InternalServerError < ServerError; end

  # 404
  class ResourceNotFound < ClientError; end

  # 405
  class MethodNotAllowed < ClientError; end

  # 415
  class UnsupportedMediaType < ClientError; end

  # 422
  class UnprocessableEntity < ClientError; end
end
