require 'kashiwamochi/configuration'
require 'kashiwamochi/search'
require 'kashiwamochi/sort'

module Kashiwamochi

  class Query
    attr_reader :search_params, :sort_params

    def initialize(attributes)
      @search_params = []
      @sort_params = []

      sort_key = Kashiwamochi.config.sort_key.to_s

      attributes ||= {}
      attributes.each do |key, value|
        if key.to_s == sort_key
          values = value.is_a?(Array) ? value : [value]
          values.each do |v|
            sort = Sort.parse(v)
            @sort_params << sort if sort.valid?
          end
        else
          search = Search.new(key, value)
          @search_params << search
          instance_eval <<-METHOD
            def attribute_#{search.key}
              search = @search_params.find { |p| p.key.to_s == "#{search.key}" }
              search.value
            end
            alias original_#{search.key} #{search.key} if defined? #{search.key}
            alias #{search.key} attribute_#{search.key}
            METHOD
        end
      end
    end

    def sorts_query(*keys)
      sortable = []
      allowed_keys = keys.flatten.map(&:to_s).uniq

      if allowed_keys.empty?
        sortable = @sort_params
      else
        allowed_keys.each do |key|
          sortable << @sort_params.find { |p| p.key.to_s == key }
        end
      end

      sortable.compact!
      sortable.empty? ? nil : sortable.map(&:to_query).join(', ')
    end
    alias_method :sorts, :sorts_query

    def inspect
      "<Query search: #{@search_params}, sort: #{@sort_params}>"
    end

    def to_option(*toggle_keys)
      toggle_keys = toggle_keys.map(&:to_s)
      hash = Hash[*@search_params.map { |p| [p.key, p.value] }.flatten]
      hash[Kashiwamochi.config.sort_key] = @sort_params.map { |p| toggle_keys.include?(p.key.to_s) ?  p.toggle : p }.map(&:to_query)
      hash
    end
  end

end
