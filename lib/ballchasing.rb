require 'json'
require 'net/http'

require_relative 'exceptions'

class Ballchasing
  def initialize(token)
    @token = token
  end

  def replays(params = {})
    uri = URI('https://ballchasing.com/api/replays')
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = @token

    response = http.request(request)
    raise BallchasingFetchError unless response.is_a?(Net::HTTPSuccess)

    return JSON.parse(response.body)
  end
end
