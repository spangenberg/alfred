module Alfred
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Alfred initializer."

      def copy_initializer
        template "alfred.rb", "config/initializers/alfred.rb"
      end
    end
  end
end
