require 'faraday'
require 'faraday_middleware'
require 'json'

require 'line_change/connection/response_handler'

module LineChange
  class Connection

    APK_MIME_TYPE = 'application/vnd.android.package-archive'.freeze
    API_KEY_HEADER = 'X-HockeyAppToken'.freeze

    Faraday::Response.register_middleware response_handler: ResponseHandler

    def initialize(adapters = [Faraday.default_adapter], logging = false)
      @conn = Faraday.new(url: 'https://rink.hockeyapp.net') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded
        faraday.request  :json

        faraday.response :logger if logging
        faraday.response :json
        faraday.response :response_handler

        faraday.adapter  *adapters
      end
    end

    def upload(path, id)
      conn.post(url(id), body(path), API_KEY_HEADER => LineChange.configuration.api_key)
    end

    private

    attr_reader :conn

    def url(id)
      "/api/2/apps/#{id}/app_versions/upload"
    end

    def body(path)
      {
        status: 2,
        notify: 0,
        notes: notes(path),
        notes_type: 0,
        ipa: Faraday::UploadIO.new(path, APK_MIME_TYPE)
      }
    end

    def notes(path)
      if /^(\d+)/ =~ File.basename(path)
        "Build number #{$1}"
      else
        "Build file #{File.basename(path)}"
      end
    end
  end
end
