require 'active_support/all'
require 'i18n'

require 'rack/builder'
require 'rack/commonlogger'
require 'rack/showexceptions'
require 'better_errors'

require 'dugway/application'
require 'dugway/liquifier'
require 'dugway/logger'
require 'dugway/request'
require 'dugway/store'
require 'dugway/template'
require 'dugway/theme'
require 'dugway/theme_font'
require 'dugway/extensions/time'

module Dugway
  def self.application(options={})
    Rack::Builder.app do
      use BetterErrors::Middleware

      if options[:log]
        BetterErrors.logger = Dugway.logger
        use Rack::CommonLogger, Dugway.logger
      end      
      
      run Application.new(options)
    end
  end
  
  def self.logger
    @logger ||= Logger.new
  end
end
