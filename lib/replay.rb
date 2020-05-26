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
    include Comparable

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
      args[:players]&.map! { |player| Player.new(player) }
      args[:stats] = TeamStats.new(args.fetch(:stats))
      super(args)
    end
  }
  private_constant :Team

  Player = KVStruct.new(:id,
                        :name,
                        :stats,
                        :start_time,
                        :end_time,
                        :car_id,
                        :car_name,
                        :camera,
                        :steering_sensitivity,
                        %i[
                          mvp
                          rank
                        ]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:id] = PlayerID.new(args.fetch(:id))
      super(args)
    end
  }
  private_constant :Player

  TeamStats = KVStruct.new(:ball,
                           :core,
                           :boost,
                           :movement,
                           :positioning,
                           :demo) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:ball] = Ball.new(args.fetch(:ball)) if args[:ball]
      args[:core] = Core.new(args.fetch(:core))
      args[:boost] = Boost.new(args.fetch(:boost))
      args[:movement] = Movement.new(args.fetch(:movement))
      args[:positioning] = Positioning.new(args.fetch(:positioning))
      args[:demo] = Demo.new(args.fetch(:demo))
      super(args)
    end
  }
  private_constant :TeamStats

  Ball = KVStruct.new(:possession_time, :time_in_side)
  private_constant :Ball

  Core = KVStruct.new(:shots,
                      :shots_against,
                      :goals,
                      :goals_against,
                      :saves,
                      :assists,
                      :score,
                      :shooting_percentage)
  private_constant :Core

  Boost = KVStruct.new(:bpm,
                       :bcpm,
                       :avg_amount,
                       :amount_collected,
                       :amount_stolen,
                       :amount_collected_big,
                       :amount_stolen_big,
                       :amount_collected_small,
                       :amount_stolen_small,
                       :count_collected_big,
                       :count_stolen_big,
                       :count_collected_small,
                       :count_stolen_small,
                       :amount_overfill,
                       :amount_overfill_stolen,
                       :amount_used_while_supersonic,
                       :time_zero_boost,
                       :time_full_boost,
                       :time_boost_0_25,
                       :time_boost_25_50,
                       :time_boost_50_75,
                       :time_boost_75_100)
  private_constant :Boost

  Movement = KVStruct.new(:total_distance,
                          :time_supersonic_speed,
                          :time_boost_speed,
                          :time_slow_speed,
                          :time_ground,
                          :time_low_air,
                          :time_high_air,
                          :time_powerslide,
                          :count_powerslide)
  private_constant :Movement

  Positioning = KVStruct.new(:time_defensive_third,
                             :time_neutral_third,
                             :time_offensive_third,
                             :time_defensive_half,
                             :time_offensive_half,
                             :time_behind_ball,
                             :time_infront_ball)
  private_constant :Positioning

  Demo = KVStruct.new(:inflicted, :taken)
  private_constant :Demo
end
