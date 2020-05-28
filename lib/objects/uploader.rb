require 'rstruct'

module Ballchasing
  Uploader = KVStruct.new(:steam_id, :name, :profile_url, :avatar) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:steam_id] = Integer(args.fetch(:steam_id), 10)
      args[:profile_url] = URI(args.fetch(:profile_url))
      args[:avatar] = URI(args.fetch(:avatar))
      super(args)
    end
  }
  private_constant :Uploader
end
