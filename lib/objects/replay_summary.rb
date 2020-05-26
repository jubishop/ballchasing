require 'date'

require 'rstruct'

module Ballchasing
  ReplaySummary = KVStruct.new(:id,
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
      args[:blue] = Team.new(args.fetch(:blue))
      args[:orange] = Team.new(args.fetch(:orange))
      args[:uploader] = Uploader.new(args.fetch(:uploader))
      super(args)
    end

    def <=>(other)
      date <=> other.date
    end
  }
  public_constant :ReplaySummary

  ##### PRIVATE #####

  Team = KVStruct.new(%i[players name goals]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:players]&.map! { |player| Player.new(player) }
      super(args)
    end
  }
  private_constant :Team

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

  PlayerID = KVStruct.new(%i[id player_number platform])
  private_constant :PlayerID

  Uploader = KVStruct.new(:steam_id, :name, :profile_url, :avatar)
  private_constant :Uploader
end
