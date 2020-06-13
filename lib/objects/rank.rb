require 'rstruct'

module Ballchasing
  Rank = KVStruct.new(:tier, :division, :name, [:id])
  private_constant :Rank
end
