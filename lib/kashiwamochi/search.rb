module Kashiwamochi

  class Search
    attr_accessor :key, :value 

    def initialize(key, value)
      @key = key
      @value = value
    end

    def inspect
      "#<Search #{key}: #{value}>"
    end
  end

end
