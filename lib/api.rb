require 'http'

require_relative 'exceptions'
require_relative 'replay'
require_relative 'replays'

module Ballchasing
  class API
    def initialize(token = ENV['BALLCHASING_TOKEN'])
      @token = token
      raise ArgumentError, "Ballchasing::API needs a token" unless @token
    end

    def replays(params = {})
      Replays.new(self, request('/api/replays', params))
    end

    def replay(id)
      Replay.new(api: self, **request("api/replays/#{id}"))
    end

    def request(path, query = {})
      uri = HTTP::URI.new(
        scheme: 'https',
        host: 'ballchasing.com',
        path: path,
        query: HTTP::URI.form_encode(query))

      begin
        response = HTTP.auth(@token).get(uri).parse
        raise Ballchasing::Error, uri unless response.status.success?
        data = response.parse
      rescue HTTP::Error
        raise Ballchasing::Error, uri
      end

      return data
    end

    # Don't let auth token get printed.
    def inspect
      return 'Ballchasing API'
    end
    alias to_s inspect
  end
end
