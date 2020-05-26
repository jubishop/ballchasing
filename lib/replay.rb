require 'rstruct'

require_relative 'objects/rank'
require_relative 'objects/uploader'

module Ballchasing
  Replay = KVStruct.new(:api,
                        :id,
                        :created,
                        :date,
                        :link,
                        :title,
                        :match_type,
                        :team_size,
                        :duration,
                        :map_code,
                        :map_name,
                        :blue,
                        :orange,
                        :playlist_id,
                        :playlist_name,
                        :rocket_league_id,
                        :season,
                        :uploader,
                        :visibility,
                        :status,
                        %i[
                          min_rank
                          max_rank
                          recorder
                        ]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:created] = DateTime.rfc3339(args.fetch(:created))
      args[:date] = DateTime.rfc3339(args.fetch(:date))
      args[:link] = URI(args.fetch(:link))
      args[:blue] = Team.new(args.fetch(:blue))
      args[:orange] = Team.new(args.fetch(:orange))
      args[:uploader] = Uploader.new(args.fetch(:uploader))
      args[:max_rank] = Rank.new(args.fetch(:max_rank)) if args[:max_rank]
      args[:min_rank] = Rank.new(args.fetch(:min_rank)) if args[:min_rank]
      super(args)
    end

    def <=>(other)
      date <=> other.date
    end
  }
  private_constant :Replay

  ##### LOCAL #####

  Team = KVStruct.new(:color, :players, :stats) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      super(args)
    end
  }
  private_constant :Team
end
