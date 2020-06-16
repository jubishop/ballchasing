require 'rstruct'

module Ballchasing
  Uploader = KVStruct.new(:steam_id, :name, :profile_url, :avatar) {
    def initialize(steam_id:, name:, profile_url:, avatar:)
      super(steam_id: steam_id.to_i,
            name: name,
            profile_url: URI(profile_url),
            avatar: avatar)
    end
  }
  private_constant :Uploader
end
