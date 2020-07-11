module Ballchasing
  class Error < RuntimeError; end
  class RequestError < Error; end
  class ResponseError < Error
    attr_reader :token, :response

    def initialize(token, response)
      @token = token
      @response = response
    end
  end
  class RateLimitError < Error
    attr_reader :token

    def initialize(token)
      @token = token
    end
  end
end
