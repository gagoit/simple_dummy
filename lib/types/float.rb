module SimpleDummyTypes
  class Float < Number
    class << self
      def random(l_digits = 5, r_digits = 2)
        l_d = Integer.random(l_digits)
        r_d = decimal_part(r_digits)

        "#{l_d}.#{r_d}".to_f
      end

      private

      def decimal_part(digits = 10)
        num = ''
        if digits > 1
          num = non_zero_digit
          digits -= 1
        end
        leading_zero_number(digits) + num
      end
    end
  end
end