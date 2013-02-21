require 'webmock/rspec'
require 'dugway'

RSpec.configure do |config|
  config.add_setting :fixture_path
  config.fixture_path = File.join(Dir.pwd, 'spec', 'fixtures')
end
