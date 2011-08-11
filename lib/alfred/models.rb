module Alfred
  module Models
    def alfred_accessible(*args)
      alfred(:accessible, *args)
    end

    def alfred_protected(*args)
      alfred(:protected, *args)
    end

  private

    def alfred(method, *args)
      options = args.extract_options!

      if options[:as]
        if method == :accessible
          args = args + accessible_attributes(options[:inherit] || :default).to_a
        else
          args = args + protected_attributes(options[:inherit] || :default).to_a
        end
        args = args + [{ as: options[:as] }]
      end

      if args.include?(:password) && Alfred.auto_password_confirmation
        args = args + [:password_confirmation]
      end

      if options[:on] && [:create, :update].include?(options[:on])
        if options[:on] == :create
          before = :before_create
        else
          before = :before_update
        end
        if method == :accessible
          self.class.send(:define_method, before) do
            attr_accessible(*args)
          end
        else
          self.class.send(:define_method, before) do
            attr_protected(*args)
          end
        end
      else
        if method == :accessible
          attr_accessible(*args)
        else
          attr_protected(*args)
        end
      end      
    end
  end
end
