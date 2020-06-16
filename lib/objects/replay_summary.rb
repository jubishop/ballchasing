require 'date'

require 'rstruct'

require_relative 'player_id'
require_relative 'rank'
require_relative 'replay_group'
require_relative 'uploader'

module Ballchasing
  ReplaySummary = KVStruct.new(:api,
                               :id,
                               :created,
                               :date,
                               :link,
                               :duration,
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
                                 groups
                                 max_rank
                                 min_rank
                                 recorder
                               ]) {
    include Comparable

    def initialize(args)
      args[:created] = DateTime.rfc3339(args.fetch(:created))
      args[:date] = DateTime.rfc3339(args.fetch(:date))
      args[:link] = URI(args.fetch(:link))
      args[:blue] = TeamSummary.new(args.fetch(:blue))
      args[:orange] = TeamSummary.new(args.fetch(:orange))
      args[:uploader] = Uploader.new(args.fetch(:uploader))
      args[:max_rank] = Rank.new(args.fetch(:max_rank)) if args[:max_rank]
      args[:min_rank] = Rank.new(args.fetch(:min_rank)) if args[:min_rank]
      args[:groups]&.map! { |group| ReplayGroup.new(group) }
      super(args)
    end

    def replay
      return @replay unless @replay.nil?

      @replay = api.replay(id)
      return @replay
    end

    def <=>(other)
      date <=> other.date
    end
  }
  private_constant :ReplaySummary

  ##### LOCAL #####

  TeamSummary = KVStruct.new(%i[players name goals]) {
    def initialize(players: [], name: nil, goals: [])
      players.map! { |player| PlayerSummary.new(player) }
      super(players: players, name: name, goals: goals)
    end
  }
  private_constant :TeamSummary

  PlayerSummary = KVStruct.new(:id,
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
      args[:id] = PlayerID.new(args.fetch(:id))
      super(args)
    end
  }
  private_constant :PlayerSummary
end
