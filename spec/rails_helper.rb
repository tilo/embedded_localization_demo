ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__) # Boot Rails

require File.expand_path('../rails_helper', __FILE__)
require 'rspec/rails'

require 'factory_bot_rails' # Ensure FactoryBot is loaded
Dir[Rails.root.join('spec', 'factories', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Automatically mix in different behaviours to your tests based on their file location
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Additional configuration can go here
end
