require 'active_support'
require 'kashiwamochi/railtie' if defined?(Rails)

module Kashiwamochi
  extend ActiveSupport::Autoload
  autoload :Configuration
  autoload :Search
  autoload :Sort
  autoload :Query
end
