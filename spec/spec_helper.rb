require 'bundler/setup'
require 's3_browser_uploads'
require 'action_controller'
module Rails
  module VERSION
    STRING = '3.2.13'
  end
end
require 'rspec/rails/adapters'
require 'rspec/rails/example/rails_example_group'
require 'rspec/rails/example/view_example_group'
require 'rspec/rails/example/helper_example_group'
require 's3_browser_uploads/view_helpers'
require 'capybara/rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end
