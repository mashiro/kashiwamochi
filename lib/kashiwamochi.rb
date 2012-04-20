require "kashiwamochi/version"

module Kashiwamochi
  autoload :Configuration, 'kashiwamochi/configuration'
  autoload :Search,        'kashiwamochi/search'
  autoload :Sort,          'kashiwamochi/sort'
  autoload :Query,         'kashiwamochi/query'

  require 'kashiwamochi/railtie' if defined?(Rails)
end
