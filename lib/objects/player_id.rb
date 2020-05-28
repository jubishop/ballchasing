require 'rstruct'
module Ballchasing
  PlayerID = KVStruct.new(%i[id player_number platform]) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      if args[:id] && Integer(args[:id], exception:false)
        args[:id] = Integer(args[:id], 10)
      end
      super(args)
    end
  }
  private_constant :PlayerID
end
