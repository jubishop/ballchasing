module Ballchasing
  ReplayGroup = KVStruct.new(:id,
                             :name,
                             :link) {
    def initialize(args)
      args.transform_keys!(&:to_sym)
      args[:link] = URI(args.fetch(:link))
      super(args)
    end
  }
  private_constant :ReplayGroup
end
