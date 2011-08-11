$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'alfred'

RSpec.configure do |config|
  config.mock_with :rr
end
