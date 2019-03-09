module SimpleDummyTypes
  class Number
    class << self
      private

      def non_zero_digit
        rand(1..9).to_s
      end

      def digit
        rand(10).to_s
      end

      def leading_zero_number(digits = 10)
        '0' + (2..digits).collect { digit }.join
      end
    end
  end
end