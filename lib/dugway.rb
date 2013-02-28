require 'active_support/all'
require 'i18n'

require 'rack/builder'
require 'rack/commonlogger'
require 'better_errors'

require 'dugway/cart'
require 'dugway/router'
require 'dugway/controller'
require 'dugway/liquifier'
require 'dugway/logger'
require 'dugway/request'
require 'dugway/store'
require 'dugway/template'
require 'dugway/theme'
require 'dugway/theme_font'
require 'dugway/extensions/time'

module Dugway
  class << self
    def application(options={})
      @store = Store.new(options[:store] || 'dugway')
      @theme = Theme.new(source_dir, options[:customization] || {})

      I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'data', 'locales', '*.yml').to_s]
      I18n.default_locale = 'en-US'
      I18n.locale = @store.locale

      Rack::Builder.app do
        use BetterErrors::Middleware

        if options[:log]
          BetterErrors.logger = Dugway.logger
          use Rack::CommonLogger, Dugway.logger
        end
        
        run Controller.new
      end
    end

    def store
      @store
    end

    def theme
      @theme
    end

    def source_dir
      @source_dir ||= File.join(Dir.pwd, 'source')
    end
    
    def logger
      @logger ||= Logger.new
    end
  end
end
