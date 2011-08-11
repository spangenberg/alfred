require 'rails'

module Alfred
  autoload :Models, 'alfred/models'

  # Automaticly add password_confirmation if password exists.
  mattr_accessor :auto_password_confirmation
  @@auto_password_confirmation = true

  # Default way to setup Alfred. Run rails generate alfred:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end

require 'alfred/engine'
require 'alfred/orm/active_record' if defined?(ActiveRecord)
