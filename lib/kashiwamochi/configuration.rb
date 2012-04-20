require 'active_support/configurable'

module Kashiwamochi
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :search_key
    config_accessor :sort_key
    config_accessor :form_class
    config_accessor :form_method
    config_accessor :sort_link_class

    configure do |config|
      config.search_key = :q
      config.sort_key = :s
      config.form_class = :search
      config.form_method = :form_for
      config.sort_link_class = :sort_link
    end
  end

  class << self
    def config
      @config ||= Kashiwamochi::Configuration.new
    end

    def configure
      yield config
    end 
  end
end
