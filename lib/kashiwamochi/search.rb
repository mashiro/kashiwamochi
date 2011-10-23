module Kashiwamochi

  class Search
    attr_reader :key, :value 

    def initialize(key, value)
      @key = key
      @value = value
    end

    def inspect
      "#<Search #{key}: #{value}>"
    end
  end

end
