require 'kashiwamochi/configuration'
require 'kashiwamochi/search'
require 'kashiwamochi/sort'

module Kashiwamochi

  class Query
    attr_accessor :search_params, :sort_params

    def initialize(attributes)
      @search_params = ActiveSupport::OrderedHash.new.with_indifferent_access
      @sort_params = ActiveSupport::OrderedHash.new.with_indifferent_access

      sort_key = Kashiwamochi.config.sort_key.to_s

      attributes ||= {}
      attributes.each do |key, value|
        if key.to_s == sort_key
          add_sort_param(key, value)
        else
          add_search_param(key, value)
        end
      end
    end

    def add_search_param(key, value)
      unless @search_params.key? key
        instance_eval <<-METHOD
          def attribute_#{key}
            search = @search_params["#{key}"]
            search.value
          end
          alias original_#{key} #{key} if defined? #{key}
          alias #{key} attribute_#{key}
        METHOD
      end

      search = Search.new(key, value)
      @search_params[search.key] = search
    end

    def add_sort_param(key, value)
      values = value.is_a?(Array) ? value : [value]
      values.each do |v|
        sort = Sort.parse(v)
        @sort_params[sort.key] = sort if sort.valid?
      end
    end

    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s
      if method_name =~ /(.+)=$/
        super
      else
        nil
      end
    end

    def sorts_query(*keys)
      allowed_keys = keys.flatten.map(&:to_s).uniq
      allowed_sorts = @sort_params.values.reject do |sort|
        !allowed_keys.empty? && !allowed_keys.include?(sort.key.to_s)
      end
      allowed_sorts.empty? ? nil : allowed_sorts.map(&:to_query).join(', ')
    end
    alias_method :sorts, :sorts_query

    def to_option
      hash = Hash[*@search_params.values.map { |search| [search.key, search.value] }.flatten]
      hash[Kashiwamochi.config.sort_key] = @sort_params.values.map(&:to_query)
      hash
    end

    def inspect
      "<Query search: #{@search_params}, sort: #{@sort_params}>"
    end

    def persisted?
      false
    end
  end

  def self.build(attributes)
    Query.new attributes
  end

end
