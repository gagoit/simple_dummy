module SimpleDummyTypes
  class Boolean
    class << self
      def random
        [true, false].sample
      end
    end
  end
end