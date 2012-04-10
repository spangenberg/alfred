require 'active_record'

module Alfred
  module ActiveRecord
    module Base
      def assign_attributes(new_attributes, options = {})
        role = (options[:as] || :default).to_s
        role << "_#{options[:action]}" if options[:action]

        options[:as] = role.to_sym

        super
      end

      def initialize(attributes = nil, options = {})
        options[:action] = :create

        super
      end

      def update_attributes(attributes, options = {})
        options[:action] = :update

        super
      end
    end
  end
end

if Alfred.override_orm
  class ActiveRecord::Base
    include Alfred::ActiveRecord::Base
  end
end
