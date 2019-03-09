module SimpleDummyTypes
  class String
    class << self
      def random(length = 32)
        english_string(length)
      end

      private

      def english_string(length)
        (0...length).map { english_characters.sample }.join
      end

      def english_characters
        @@english_characters ||= [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      end
    end
  end
end