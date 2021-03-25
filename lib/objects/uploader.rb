require 'rstruct'

module Ballchasing
  Uploader = KVStruct.new(:steam_id, :name, :profile_url, :avatar) {
    def initialize(args)
      args[:steam_id] = args.fetch(:steam_id).to_i
      args[:profile_url] = URI(args.fetch(:profile_url))
      super(args)
    end
  }
  private_constant :Uploader
end
