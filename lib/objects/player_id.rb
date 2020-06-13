require 'rstruct'

module Ballchasing
  PlayerID = KVStruct.new(%i[id platform player_number])
  private_constant :PlayerID
end
