# frozen_string_literal: true

require 'bundler/setup'
require 'coveralls'
Coveralls.wear!
require 'restclient/opentracing'
require 'opentracing_test_tracer'
require 'webmock'

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    WebMock.enable!
  end
end
