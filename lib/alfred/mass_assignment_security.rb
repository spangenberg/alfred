require 'active_model'

module Alfred
  module ActiveModel
    module MassAssignmentSecurity
      module ClassMethods
        # Attributes named in this macro are protected from mass-assignment
        # whenever attributes are sanitized before assignment. A role for the
        # attributes is optional, if no role is provided then :default is used.
        # A role can be defined by using the :as option.
        #
        # Mass-assignment to these attributes will simply be ignored, to assign
        # to them you can use direct writer methods. This is meant to protect
        # sensitive attributes from being overwritten by malicious users
        # tampering with URLs or forms. Example:
        #
        #   class Customer
        #     include ActiveModel::MassAssignmentSecurity
        #     extend Alfred::ActiveModel::MassAssignmentSecurity
        #
        #     attr_accessor :name, :credit_rating
        #
        #     alfred_protected :credit_rating
        #     alfred_protected :last_login, as: :trainee
        #
        #     def assign_attributes(values, options = {})
        #       sanitize_for_mass_assignment(values, options[:as]).each do |k, v|
        #         send("#{k}=", v)
        #       end
        #     end
        #   end
        #
        # When using the :default role :
        #
        #   customer = Customer.new
        #   customer.assign_attributes({ name: "Daniel", credit_rating: "Excellent", last_login: 1.day.ago }, as: :default)
        #   customer.name          # => "Daniel"
        #   customer.credit_rating # => nil
        #   customer.last_login    # => nil
        #
        #   customer.credit_rating = "Average"
        #   customer.credit_rating # => "Average"
        #
        # And using the :admin role :
        #
        #   customer = Customer.new
        #   customer.assign_attributes({ name: "Daniel", credit_rating: "Excellent", last_login: 1.day.ago }, as: :trainee)
        #   customer.name          # => "Daniel"
        #   customer.credit_rating # => "Excellent"
        #   customer.last_login    # => nil
        #
        # To start from an all-closed default and enable attributes as needed,
        # have a look at +alfred_accessible+.
        #
        # Note that using <tt>Hash#except</tt> or <tt>Hash#slice</tt> in place of +alfred_protected+
        # to sanitize attributes won't provide sufficient protection.
        def alfred_protected(*args)
          alfred(:protected, *args)
        end

        # Specifies a white list of model attributes that can be set via
        # mass-assignment.
        #
        # Like +alfred_protected+, a role for the attributes is optional,
        # if no role is provided then :default is used. A role can be defined by
        # using the :as option.
        #
        # This is the opposite of the +alfred_protected+ macro: Mass-assignment
        # will only set attributes in this list, to assign to the rest of
        # attributes you can use direct writer methods. This is meant to protect
        # sensitive attributes from being overwritten by malicious users
        # tampering with URLs or forms. If you'd rather start from an all-open
        # default and restrict attributes as needed, have a look at
        # +alfred_protected+.
        #
        #   class Customer
        #     include ActiveModel::MassAssignmentSecurity
        #     extend Alfred::ActiveModel::MassAssignmentSecurity
        #
        #     attr_accessor :name, :credit_rating
        #
        #     alfred_accessible :name
        #     alfred_accessible :credit_rating, as: :admin
        #
        #     def assign_attributes(values, options = {})
        #       sanitize_for_mass_assignment(values, options[:as]).each do |k, v|
        #         send("#{k}=", v)
        #       end
        #     end
        #   end
        #
        # When using the :default role :
        #
        #   customer = Customer.new
        #   customer.assign_attributes({ name: "Daniel", credit_rating: "Excellent", last_login: 1.day.ago }, as: :default)
        #   customer.name          # => "Daniel"
        #   customer.credit_rating # => nil
        #
        #   customer.credit_rating = "Average"
        #   customer.credit_rating # => "Average"
        #
        # And using the :admin role :
        #
        #   customer = Customer.new
        #   customer.assign_attributes({ name: "Daniel", credit_rating: "Excellent", last_login: 1.day.ago }, as: :admin)
        #   customer.name          # => "Daniel"
        #   customer.credit_rating # => "Excellent"
        #
        # Note that using <tt>Hash#except</tt> or <tt>Hash#slice</tt> in place of +alfred_accessible+
        # to sanitize attributes won't provide sufficient protection.
        def alfred_accessible(*args)
          alfred(:accessible, *args)
        end

        private
        def role(as = nil, action = nil)
        	role = (as || :default).to_s
          role << "_#{action}" if action
          role.to_sym
        end

        def alfred(method, *args)
          options = args.extract_options!

          if args.include?(:password) && Alfred.auto_password_confirmation
            args = [:password_confirmation] + args
          end

          [nil, :create, :update].each do |action|
            next if !options[:on] && options[:on] != action

            action_args = args.dup
            role = role(options[:as], action)

            action_args = send("#{method}_attributes", role(:default, action)).to_a.compact.reject { |s| s.blank? } + action_args
            action_args = send("#{method}_attributes", role(options[:inherit], action)).to_a.compact.reject { |s| s.blank? } + action_args if options[:inherit]
            action_args = action_args + [{ as: role }]

            send("attr_#{method}", *action_args)
          end
        end
      end

      include ClassMethods
    end
  end
end

module ActiveModel::MassAssignmentSecurity::ClassMethods
  include Alfred::ActiveModel::MassAssignmentSecurity
end
