module Ballchasing
  class Error < RuntimeError; end
  class RequestError < Error; end
  class ResponseError < Error; end
  class RateLimitError < Error; end
end
