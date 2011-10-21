require 'kashiwamochi/action_view_extension'

module Kashiwamochi
  class Railtie < Rails::Railtie
    initializer 'kashiwamochi.initialize' do
      ActiveSupport.on_load(:action_view) do
        include Kashiwamochi::ActionViewExtension
      end
    end
  end
end
