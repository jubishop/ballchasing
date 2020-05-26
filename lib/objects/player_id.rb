require 'rstruct'
module Ballchasing
  PlayerID = KVStruct.new(%i[id player_number platform])
  private_constant :PlayerID
end
