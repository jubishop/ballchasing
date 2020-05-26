require 'rstruct'

module Ballchasing
  Rank = KVStruct.new(:id, :tier, :division, :name)
  private_constant :Rank
end
