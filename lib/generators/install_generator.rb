module Kashiwamochi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copied Kashiwamochi default files'
      source_root File.expand_path('../templates', __FILE__)

      def copy_config_file
        template 'config/initializers/kashiwamochi.rb'
      end
    end
  end
end

