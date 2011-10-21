module Kashiwamochi
  module ActionViewExtension
    extend ActiveSupport::Concern

    module InstanceMethod
      def search_form_for(query, *args, &block)
        options = args.extract_options!
        options[:url] ||= url_for
        options[:as] ||= :q
        options[:method] ||= :get
        options[:html] ||= {}
        options[:html].tap do |html|
          html.reverse_merge!({
            :id => "#{options[:as]}_search",
            :class => "#{options[:as]}_search",
            :method => :get
          })
          html[:class] += ' search'
        end

        form_method = options.delete(:form_method) || :form_for
        send(form_method, query, *(args << options), &block)
      end
    end
  end
end
