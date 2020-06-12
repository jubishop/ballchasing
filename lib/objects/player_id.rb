require 'rstruct'

module Ballchasing
  PlayerID = KVStruct.new(%i[id platform])
  private_constant :PlayerID
end
