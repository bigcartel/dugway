require 'active_support/all'

require 'dugway/application'
require 'dugway/liquifier'
require 'dugway/request'
require 'dugway/store'
require 'dugway/template'
require 'dugway/theme'

module Dugway
  def self.application(options={})
    Application.new(options) do
      use Rack::CommonLogger, logger
      use Rack::ShowExceptions
      use BetterErrors::Middleware
      
      BetterErrors.logger = logger
      BetterErrors.application_root = Dir.pwd
    end
  end
  
  def self.logger
    @logger ||= Logger.new(File.join(Dir.pwd, 'log', 'dugway.log'))
  end
end
