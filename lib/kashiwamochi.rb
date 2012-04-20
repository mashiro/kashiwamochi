require "kashiwamochi/version"
require 'kashiwamochi/railtie' if defined?(Rails)

module Kashiwamochi
  autoload :Configuration, 'kashiwamochi/configuration'
  autoload :Search,        'kashiwamochi/search'
  autoload :Sort,          'kashiwamochi/sort'
  autoload :Query,         'kashiwamochi/query'
end
