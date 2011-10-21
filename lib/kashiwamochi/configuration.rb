module Kashiwamochi
  def self.config
    @config ||= Kashiwamochi::Configuration.new
  end

  def self.configure
    yield config
  end 

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :search_key
    config_accessor :sort_key
    config_accessor :form_class
    config_accessor :form_method

    configure do |config|
      config.search_key = :q
      config.sort_key = :s
      config.form_class = :search
      config.form_method = :form_for
    end
  end
end
