require 'webmock/rspec'
require 'dugway'

RSpec.configure do |config|
  config.add_setting :fixture_path
  config.fixture_path = File.join(Dir.pwd, 'spec', 'fixtures')
end

Spec::Runner.configure do |config|
  config.before(:each) do
    stub_request(:get, /.*api\.bigcartel\.com.*/).to_return(lambda { |request|
      { :body => File.new(File.join(RSpec.configuration.fixture_path, 'store', request.uri.path.split('/', 3).last)), :status => 200, :headers => {} }
    })
  end
end
