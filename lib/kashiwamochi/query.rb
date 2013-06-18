require 'active_support/ordered_hash'
require 'active_support/core_ext/hash/indifferent_access'

module Kashiwamochi
  class Query
    attr_reader :search_params, :sort_params

    def initialize(attributes = {})
      @search_params = {}.with_indifferent_access
      @sort_params = {}.with_indifferent_access
      sort_key = Kashiwamochi.config.sort_key.to_s

      attributes.each do |key, value|
        if key.to_s == sort_key
          add_sort_param key, value
        else
          add_search_param key, value
        end
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

    def add_sort_param(key, value)
      values = Array(value)
      values.each do |v|
        sort = Sort.parse(v)
        @sort_params[sort.key] = sort if sort.valid?
      end
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

    def sorts_query(*args)
      if args.first.is_a? Hash
        params = args.first
      else
        params = Hash[*args.map { |v| [v, v] }.flatten]
      end

      params.stringify_keys!
      allowed_sorts = []

      if params.empty?
        allowed_sorts = @sort_params.values
      else
        allowed_sorts = params.keys.map { |k| @sort_params[k] }
        allowed_sorts.reject! { |s| s.nil? }
      end

      return nil if allowed_sorts.empty?
      allowed_sorts.map { |s| s.to_query(params[s.key]) }.join(', ')
    end
    alias_method :sorts, :sorts_query

    def to_option(*sort_keys)
      sort_keys = sort_keys.flatten.map(&:to_s).uniq
      sorts = @sort_params.values
      sorts.reject! { |s| !sort_keys.include?(s.key.to_s) } unless sort_keys.empty?

      hash = Hash[*@search_params.values.map { |search| [search.key, search.value] }.flatten]
      unless sorts.empty?
        hash[Kashiwamochi.config.sort_key] = case sorts.length
                                             when 1 then sorts.first.to_query
                                             else        sorts.map(&:to_query)
                                             end
      end
      hash
    end

    def inspect
      "<Query search: #{@search_params}, sort: #{@sort_params}>"
    end

    def persisted?
      false
    end

    def searched?
      !@search_params.empty? || !@sort_params.empty?
    end
  end
end
