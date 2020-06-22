require 'rstruct'

module Ballchasing
  PlayerID = KVStruct.new(%i[id platform player_number]) {
    def ==(other)
      if other.is_a?(PlayerID)
        return id == other.id && platform == other.platform
      end

      super(other)
    end
    alias_method :eql?, :==
  }
  private_constant :PlayerID
end
