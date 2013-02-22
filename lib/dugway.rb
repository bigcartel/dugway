require 'active_support/all'

require 'rack/builder'
require 'rack/commonlogger'
require 'rack/showexceptions'

require 'better_errors'

require 'dugway/application'
require 'dugway/liquifier'
require 'dugway/request'
require 'dugway/store'
require 'dugway/template'
require 'dugway/theme'

module Dugway
  def self.application(options={})
    Rack::Builder.app do
      use Rack::CommonLogger, Dugway.logger(options[:log])
      use Rack::ShowExceptions
      use BetterErrors::Middleware
      
      BetterErrors.logger = Dugway.logger(options[:log])
      BetterErrors.application_root = Dir.pwd
      
      run Application.new(options)
    end
  end
  
  def self.logger(local=false)
    @logger ||= begin
      return nil unless local
      dir = File.join(Dir.pwd, 'log')
      Dir.mkdir(dir) unless File.exists?(dir)
      Logger.new(File.join(dir, 'dugway.log'))
    end
  end
end
