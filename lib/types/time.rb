module SimpleDummyTypes
  class Time
    class << self
      def random(format = '%Y-%m-%d %H:%M:%S')
        ::Time.now.strftime(format)
      end
    end
  end

  class Date
    class << self
      def random(format = '%Y-%m-%d')
        Time.random(format)
      end
    end
  end  
end