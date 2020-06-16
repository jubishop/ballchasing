module Ballchasing
  ReplayGroup = KVStruct.new(:id, :name, :link) {
    def initialize(id:, name:, link:)
      super(id: id, name: name, link: URI(link))
    end
  }
  private_constant :ReplayGroup
end
