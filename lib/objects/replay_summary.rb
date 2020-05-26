require 'date'

require 'rstruct'

require_relative 'player_id'
require_relative 'rank'
require_relative 'uploader'

module Ballchasing
  ReplaySummary = KVStruct.new(:api,
                               :id,
                               :created,
                               :date,
                               :duration,
                               :link,
                               :map_code,
                               :map_name,
                               :blue,
                               :orange,
                               :playlist_id,
                               :playlist_name,
                               :replay_title,
                               :rocket_league_id,
                               :season,
                               :uploader,
                               :visibility,
                               %i[
                                 max_rank
                                 min_rank
                                 recorder
                               ]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:created] = DateTime.rfc3339(args.fetch(:created))
      args[:date] = DateTime.rfc3339(args.fetch(:date))
      args[:link] = URI(args.fetch(:link))
      args[:blue] = TeamSummary.new(args.fetch(:blue))
      args[:orange] = TeamSummary.new(args.fetch(:orange))
      args[:uploader] = Uploader.new(args.fetch(:uploader))
      args[:max_rank] = Rank.new(args.fetch(:max_rank)) if args[:max_rank]
      args[:min_rank] = Rank.new(args.fetch(:min_rank)) if args[:min_rank]
      super(args)
    end

    def replay
      return api.replay(id)
    end

    def <=>(other)
      date <=> other.date
    end
  }
  private_constant :ReplaySummary

  ##### LOCAL #####

  TeamSummary = KVStruct.new(%i[players name goals]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:players]&.map! { |player| Player.new(player) }
      super(args)
    end
  }
  private_constant :TeamSummary

  Player = KVStruct.new(:id,
                        :score,
                        :start_time,
                        :end_time,
                        %i[
                          name
                          mvp
                          pro
                          rank
                        ]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:id] = PlayerID.new(args.fetch(:id))
      super(args)
    end
  }
  private_constant :Player
end
