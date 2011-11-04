require 'kashiwamochi/action_controller'
require 'kashiwamochi/action_view'

module Kashiwamochi
  class Railtie < Rails::Railtie
    initializer 'kashiwamochi.initialize' do
      ActiveSupport.on_load(:action_controller) do
        include Kashiwamochi::ActionController
      end
      ActiveSupport.on_load(:action_view) do
        include Kashiwamochi::ActionView
      end
    end
  end
end
