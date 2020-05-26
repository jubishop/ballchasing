require 'json'
require 'net/http'

require_relative 'exceptions'
require_relative 'replays'

module Ballchasing
  class API
    def initialize(token = ENV['BALLCHASING_TOKEN'])
      @token = token
    end

    def replays(params = {})
      uri = URI('https://ballchasing.com/api/replays')
      uri.query = URI.encode_www_form(params)
      Replays.new(self, request(uri))
    end

    def request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request['Authorization'] = @token

      response = http.request(request)
      raise BallchasingFetchError unless response.is_a?(Net::HTTPSuccess)

      return JSON.parse(response.body)
    end

    # Don't let auth token get printed.
    def inspect
      return 'Ballchasing API'
    end
    alias to_s inspect
  end
end
