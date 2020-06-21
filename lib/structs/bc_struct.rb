require 'rstruct'

module Ballchasing
  class BCStruct < KVStruct
    def initialize(args)
      args.each { |key, value|
        args[key] = value.seconds if key.start_with?('time')
      }
      super(args)
    end
  end
  private_constant :BCStruct
end
