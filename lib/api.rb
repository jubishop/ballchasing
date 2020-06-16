require 'http'

require 'core'

require_relative 'exceptions'
require_relative 'replay'
require_relative 'replays'

module Ballchasing
  class API
    def initialize(token = ENV['BALLCHASING_TOKEN'])
      @token = token
      raise ArgumentError, 'Ballchasing::API needs a token' unless @token
    end

    def replays(params = {}) # rubocop:disable Style/OptionHash
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
        response = HTTP.auth(@token).get(uri)
        raise RateLimitError, response if response.status.code == 429
        raise ResponseError, response unless response.status.success?

        data = response.parse
      rescue HTTP::Error => e
        raise RequestError, e
      end

      data.deep_symbolize_keys!
      return data
    end

    # Don't let auth token get printed.
    def inspect
      return 'Ballchasing API'
    end
    alias to_s inspect
  end
end
