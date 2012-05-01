require 'active_support/ordered_hash'
require 'active_support/core_ext/hash/indifferent_access'

module Kashiwamochi
  class Query
    attr_accessor :search_params, :sort_param

    def initialize(attributes = {})
      attributes = attributes.dup
      attributes.with_indifferent_access

      @search_params = ActiveSupport::OrderedHash.new.with_indifferent_access
      @sort_param = Sort.parse(attributes.delete(Kashiwamochi.config.sort_key))

      attributes.each do |key, value|
        add_search_param(key, value)
      end
    end

    def add_search_param(key, value)
      unless @search_params.key? key
        instance_eval <<-METHOD
          def attribute_#{key}
            search = @search_params[:#{key}]
            search.value
          end
          alias original_#{key} #{key} if defined? #{key}
          alias #{key} attribute_#{key}
        METHOD
      end

      search = Search.new(key, value)
      @search_params[search.key] = search
    end

    def respond_to?(method_id, include_private = false)
      super || respond_to_missing?(method_id, include_private)
    end

    def respond_to_missing?(method_id, include_private)
      method_name = method_id.to_s
      return true if method_name =~ /(.+)=$/
      super
    end 

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s
      if method_name =~ /(.+)=$/
        super
      else
        nil
      end
    end

    def sort_query(*keys)
      allowed_keys = keys.flatten.map(&:to_s).uniq
      if allowed_keys.empty? || allowed_keys.include?(@sort_param.key.to_s)
        @sort_param.to_query
      else
        nil
      end
    end
    alias_method :sort, :sort_query

    def to_option
      hash = Hash[*@search_params.values.map { |search| [search.key, search.value] }.flatten]
      hash[Kashiwamochi.config.sort_key] = @sort_param.to_query
      hash
    end

    def inspect
      "<Query search: #{@search_params}, sort: #{@sort_param}>"
    end

    def persisted?
      false
    end
  end
end
