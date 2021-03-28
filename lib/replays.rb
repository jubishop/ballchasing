require_relative 'objects/replay_summary'

module Ballchasing
  class Replays
    include Enumerable

    def initialize(api, data)
      @api = api
      @replay_summaries = data[:list].map { |summary|
        ReplaySummary.new(api: @api, **summary)
      }
      @next = URI.parse(data.fetch(:next)) if data[:next]
    end

    def each(&block)
      @replay_summaries.each(&block)
    end

    def next
      return unless @next

      return Replays.new(@api, @api.request(@next))
    end
  end
end
