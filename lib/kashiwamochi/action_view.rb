module Kashiwamochi
  module ActionView
    extend ActiveSupport::Concern

    def search_form_for(query, *args, &block)
      options = args.extract_options!

      options[:url] ||= url_for
      options[:as] ||= Kashiwamochi.config.search_key
      options[:method] ||= :get

      html_options = options[:html] ||= {}
      html_options[:id] ||= "#{options[:as]}_#{Kashiwamochi.config.form_class}"
      html_options[:class] = [Kashiwamochi.config.form_class, html_options[:class]].compact.join(' ')

      form_method = options.delete(:form_method) || Kashiwamochi.config.form_method
      __send__(form_method, query, *(args << options), &block)
    end

    def search_sort_link_to(query, attribute, *args)
      options = args.extract_options!
      html_options = options.delete(:html_options) || {}
      default_order = options.delete(:default_order)

      attr_name = attribute.to_s
      current_sort = query.sort_params[attr_name]

      classes = []
      classes << (html_options[:class] || "#{attr_name}_#{Kashiwamochi.config.sort_link_class}")
      classes << Kashiwamochi.config.sort_link_class

      if current_sort
        classes << current_sort.dir.downcase
        query.sort_params[attr_name] = current_sort.toggle
      else
        query.sort_params[attr_name] = Kashiwamochi::Sort.new(attr_name, default_order)
      end

      html_options[:class] = classes.compact.join(' ')
      options[Kashiwamochi.config.search_key] = query.to_option(attr_name)

      name = args.shift || attr_name
      link_to(name, options, html_options)
    end
    alias_method :sort_link_to, :search_sort_link_to unless defined?(sort_link_to)
  end
end
