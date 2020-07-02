require 'rstruct'

module Ballchasing
  class BCStruct < KVStruct
    def initialize(args)
      args.each { |key, value|
        if key.start_with?('time') || key.end_with?('duration')
          args[key] = value.seconds
        end
      }
      super(args)
    end
  end
  private_constant :BCStruct
end
