require 'rstruct'
module Ballchasing
  PlayerID = KVStruct.new(%i[id player_number platform]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      super(args)
    end
  }
  private_constant :PlayerID
end
