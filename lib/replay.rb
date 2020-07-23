require 'date'

require 'duration'
require 'rstruct'

require_relative 'structs/bc_struct'

require_relative 'objects/rank'
require_relative 'objects/replay_group'
require_relative 'objects/uploader'

module Ballchasing
  Replay = KVStruct.new(:raw_data,
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
                        :overtime,
                        %i[
                          groups
                          min_rank
                          max_rank
                          recorder
                          overtime_seconds
                        ]) {
    include Comparable

    def initialize(args)
      args[:created] = DateTime.rfc3339(args.fetch(:created)).to_time
      args[:date] = DateTime.rfc3339(args.fetch(:date)).to_time
      args[:link] = URI(args.fetch(:link))
      args[:duration] = args.fetch(:duration).seconds
      args[:blue] = Team.new(args.fetch(:blue))
      args[:orange] = Team.new(args.fetch(:orange))
      args[:uploader] = Uploader.new(args.fetch(:uploader))
      args[:max_rank] = Rank.new(args.fetch(:max_rank)) if args[:max_rank]
      args[:min_rank] = Rank.new(args.fetch(:min_rank)) if args[:min_rank]
      args[:groups]&.map! { |group| ReplayGroup.new(group) }
      super(args)
    end

    def <=>(other)
      date <=> other.date
    end
  }
  public_constant :Replay

  #####################################
  # LOCAL
  #####################################

  ##### SHARED #####

  Demo = KVStruct.new(:inflicted, :taken)
  private_constant :Demo

  Ball = KVStruct.new(%i[time_in_side possession_time])
  private_constant :Ball

  ##### TEAM #####

  Team = KVStruct.new(:color, :players, :stats, [:name]) {
    def initialize(args)
      args[:players].map! { |player| Player.new(player) }
      args[:stats] = TeamStats.new(args.fetch(:stats))
      super(args)
    end
  }
  private_constant :Team

  TeamStats = KVStruct.new(:ball,
                           :core,
                           :boost,
                           :movement,
                           :positioning,
                           :demo) {
    def initialize(args)
      super(ball: Ball.new(args.fetch(:ball)),
            core: TeamCore.new(args.fetch(:core)),
            boost: TeamBoost.new(args.fetch(:boost)),
            movement: TeamMovement.new(args.fetch(:movement)),
            positioning: TeamPositioning.new(args.fetch(:positioning)),
            demo: Demo.new(args.fetch(:demo)))
    end
  }
  private_constant :TeamStats

  TeamCore = KVStruct.new(:shots,
                          :shots_against,
                          :goals,
                          :goals_against,
                          :saves,
                          :assists,
                          :score,
                          :shooting_percentage)
  private_constant :TeamCore

  TeamBoost = BCStruct.new(:bpm,
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
  private_constant :TeamBoost

  TeamMovement = BCStruct.new(:total_distance,
                              :time_supersonic_speed,
                              :time_boost_speed,
                              :time_slow_speed,
                              :time_ground,
                              :time_low_air,
                              :time_high_air,
                              :time_powerslide,
                              :count_powerslide)
  private_constant :TeamMovement

  TeamPositioning = BCStruct.new(:time_defensive_third,
                                 :time_neutral_third,
                                 :time_offensive_third,
                                 :time_defensive_half,
                                 :time_offensive_half,
                                 :time_behind_ball,
                                 :time_infront_ball)
  private_constant :TeamPositioning

  ###### PLAYER #####

  Player = KVStruct.new(:id,
                        :stats,
                        :start_time,
                        :end_time,
                        :car_id,
                        :camera,
                        :steering_sensitivity,
                        %i[
                          car_name
                          name
                          mvp
                          rank
                        ]) {
    def initialize(args)
      args[:id] = PlayerID.new(args.fetch(:id))
      args[:stats] = PlayerStats.new(args.fetch(:stats))
      args[:camera] = Camera.new(args.fetch(:camera))
      args[:rank] = Rank.new(args.fetch(:rank)) if args[:rank]
      super(args)
    end

    def ==(other)
      return id == other.id if other.is_a?(Player)

      super(other)
    end
    alias_method :eql?, :==

    def hash
      return id.hash
    end
  }
  private_constant :Player

  PlayerStats = KVStruct.new(:core,
                             :boost,
                             :movement,
                             :positioning,
                             :demo) {
    def initialize(args)
      super(core: PlayerCore.new(args.fetch(:core)),
            boost: PlayerBoost.new(args.fetch(:boost)),
            movement: PlayerMovement.new(args.fetch(:movement)),
            positioning: PlayerPositioning.new(args.fetch(:positioning)),
            demo: Demo.new(args.fetch(:demo)))
    end
  }
  private_constant :PlayerStats

  PlayerCore = KVStruct.new(:shots,
                            :shots_against,
                            :goals,
                            :goals_against,
                            :saves,
                            :assists,
                            :score,
                            :mvp,
                            :shooting_percentage)
  private_constant :PlayerCore

  PlayerBoost = BCStruct.new(:bpm,
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
                             :time_boost_75_100,
                             :percent_zero_boost,
                             :percent_full_boost,
                             :percent_boost_0_25,
                             :percent_boost_25_50,
                             :percent_boost_50_75,
                             :percent_boost_75_100)
  private_constant :PlayerBoost

  PlayerMovement = BCStruct.new(:avg_speed,
                                :total_distance,
                                :time_supersonic_speed,
                                :time_boost_speed,
                                :time_slow_speed,
                                :time_ground,
                                :time_low_air,
                                :time_high_air,
                                :time_powerslide,
                                :count_powerslide,
                                :avg_powerslide_duration,
                                :avg_speed_percentage,
                                :percent_slow_speed,
                                :percent_boost_speed,
                                :percent_supersonic_speed,
                                :percent_ground,
                                :percent_low_air,
                                :percent_high_air)
  private_constant :PlayerMovement

  PlayerPositioning = BCStruct.new(:avg_distance_to_ball,
                                   :avg_distance_to_ball_possession,
                                   :avg_distance_to_ball_no_possession,
                                   :time_defensive_third,
                                   :time_neutral_third,
                                   :time_offensive_third,
                                   :time_defensive_half,
                                   :time_offensive_half,
                                   :time_behind_ball,
                                   :time_infront_ball,
                                   :percent_defensive_third,
                                   :percent_offensive_third,
                                   :percent_neutral_third,
                                   :percent_defensive_half,
                                   :percent_offensive_half,
                                   :percent_behind_ball,
                                   :percent_infront_ball,
                                   %i[
                                     avg_distance_to_mates
                                     goals_against_while_last_defender
                                     time_most_back
                                     time_most_forward
                                     time_closest_to_ball
                                     time_farthest_from_ball
                                     percent_most_back
                                     percent_most_forward
                                     percent_closest_to_ball
                                     percent_farthest_from_ball
                                   ])
  private_constant :PlayerPositioning

  Camera = KVStruct.new(:fov,
                        :height,
                        :pitch,
                        :distance,
                        :stiffness,
                        :swivel_speed,
                        :transition_speed)
  private_constant :Camera
end
