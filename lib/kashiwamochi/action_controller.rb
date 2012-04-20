module Kashiwamochi
  module ActionController
    extend ActiveSupport::Concern

    def build_search_query!
      q = params.delete(Kashiwamochi.config.search_key) || {}
      instance_variable_set("@#{Kashiwamochi.config.search_key}", Kashiwamochi.build(q))
    end
    alias_method :build_query!, :build_search_query! unless defined?(build_query!)
  end
end
