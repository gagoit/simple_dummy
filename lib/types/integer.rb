module SimpleDummyTypes
  class Integer < Number
    class << self
      def random(digits = 10)
        num = ''

        if digits > 1
          num = non_zero_digit
          digits -= 1
        end

        (num << (1..digits).collect { digit }.join).to_i
      end
    end
  end
end