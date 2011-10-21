module Kashiwamochi
  class Railtie < Rails::Railtie
    initializer 'kashiwamochi.initialize' do
      ActiveSupport.on_load(:action_view) do
        require 'kashiwamochi/action_view_extension'
        include Kashiwamochi::ActionViewExtension
      end
    end
  end
end
