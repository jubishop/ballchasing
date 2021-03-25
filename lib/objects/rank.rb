require 'rstruct'

module Ballchasing
  Rank = KVStruct.new(:tier, :name, %i[division id])
  private_constant :Rank
end
