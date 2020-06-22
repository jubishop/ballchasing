module Ballchasing
  class Error < RuntimeError; end
  class RequestError < Error; end
  class ResponseError < Error
    attr_reader :response
    def initialize(response)
      @response = response
    end
  end
  class RateLimitError < Error; end
end
