require "kashiwamochi/version"
require 'kashiwamochi/railtie' if defined?(Rails)

module Kashiwamochi
  autoload :Configuration, 'kashiwamochi/configuration'
  autoload :Search,        'kashiwamochi/search'
  autoload :Sort,          'kashiwamochi/sort'
  autoload :Query,         'kashiwamochi/query'

  class << self
    def config
      @config ||= Kashiwamochi::Configuration.new
    end

    def configure
      yield config
    end 

    def build(attributes)
      Query.new attributes
    end
  end
end
