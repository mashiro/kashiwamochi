module Kashiwamochi
  module ActionViewExtension
    extend ActiveSupport::Concern

    module InstanceMethods

      def search_form_for(query, *args, &block)
        options = args.extract_options!

        options[:url] ||= url_for
        options[:as] ||= Kashiwamochi.config.search_key
        options[:method] ||= :get
        options[:html] ||= {}
        options[:html].tap do |html|
          html[:id] ||= "#{options[:as]}_#{Kashiwamochi.config.form_class}"
          html[:class] = [
            html[:class] || "#{options[:as]}_#{Kashiwamochi.config.form_class}",
            "#{Kashiwamochi.config.form_class}"
          ].compact.join(' ')
          html[:method] ||= :get
        end

        form_method = options.delete(:form_method) || Kashiwamochi.config.form_method
        send(form_method, query, *(args << options), &block)
      end

      def search_sort_link_to(query, attribute, *args)
        options = args.extract_options!
        html_options = options.delete(:html_options) || {}
        default_order = options.delete(:default_order)

        attr_name = attribute.to_s
        sort = query.sort_params.find { |p| p.key.to_s == attr_name }

        html_options[:class] = [
          html_options[:class] || "#{attr_name}_#{Kashiwamochi.config.sort_link_class}",
          Kashiwamochi.config.sort_link_class,
          sort && sort.dir.downcase
        ].compact.join(' ')

        options[Kashiwamochi.config.search_key] = query.to_option(attr_name)
        name = args.shift || attr_name

        link_to(name, url_for(options), html_options)
      end
      alias_method :sort_link_to, :search_sort_link_to unless defined?(sort_link_to)

    end
  end
end
