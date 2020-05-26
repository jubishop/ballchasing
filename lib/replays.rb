require_relative 'api'
require_relative 'objects/replay_summary'

module Ballchasing
  class Replays
    include Enumerable

    attr_reader :replays

    def initialize(api, data)
      data.transform_keys!(&:to_sym)

      @api = api
      @replays = data[:list].map { |summary| ReplaySummary.new(summary) }
      @next = URI.parse(data[:next])
    end

    def each
      @replays.each { |replay| yield replay }
    end

    def next
      return Replays.new(@api, @api.request(@next))
    end
  end
end
