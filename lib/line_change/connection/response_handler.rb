module LineChange
  class Connection
    class ResponseHandler < Faraday::Response::Middleware
      ClientErrorStatuses = (400...500).freeze
      ServerErrorStatuses = (500...600).freeze

      def on_complete(env)
        case env[:status]
        when 404
          raise LineChange::ResourceNotFound, response_values(env)
        when 405
          raise LineChange::MethodNotAllowed, response_values(env)
        when 415
          raise LineChange::UnsupportedMediaType, response_values(env)
        when 422
          raise LineChange::UnprocessableEntity, response_values(env)
        when ClientErrorStatuses
          raise LineChange::ClientError, response_values(env)
        when ServerErrorStatuses
          raise LineChange::ServerError, response_values(env)
        end
      end

      def response_values(env)
        {status: env.status, headers: env.response_headers, body: env.body}
      end
    end
  end
end
