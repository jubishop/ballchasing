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
                               :blue,
                               :orange,
                               :playlist_id,
                               :playlist_name,
                               :replay_title,
                               :rocket_league_id,
                               :season,
                               :uploader,
                               :visibility,
                               :overtime,
                               %i[
                                 groups
                                 max_rank
                                 min_rank
                                 recorder
                                 map_name
                                 overtime_seconds
                               ]) {
    include Comparable

    def initialize(args)
      args[:created] = DateTime.rfc3339(args.fetch(:created)).to_time
      args[:date] = DateTime.rfc3339(args.fetch(:date)).to_time
      args[:link] = URI(args.fetch(:link))
      args[:duration] = args.fetch(:duration).seconds
      args[:blue] = TeamSummary.new(**args.fetch(:blue))
      args[:orange] = TeamSummary.new(**args.fetch(:orange))
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

  class TeamSummary
    attr_reader :players, :name, :goals

    def initialize(players: [], name: nil, goals: [])
      players.map! { |player| PlayerSummary.new(player) }
      @players = players
      @name = name
      @goals = goals
    end
  end
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
