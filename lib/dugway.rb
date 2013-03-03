require 'active_support/all'
require 'i18n'

require 'rack/builder'
require 'rack/commonlogger'
require 'better_errors'

require 'dugway/version'
require 'dugway/application'
require 'dugway/cart'
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
      @options = options

      I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'data', 'locales', '*.yml').to_s]
      I18n.default_locale = 'en-US'
      I18n.locale = Dugway.store.locale

      Rack::Builder.app do
        use Rack::Session::Cookie, :secret => 'stopwarningmeaboutnothavingasecret'
        use BetterErrors::Middleware
        
        if options[:log]
          BetterErrors.logger = Dugway.logger
          use Rack::CommonLogger, Dugway.logger
        end
        
        run Application.new
      end
    end

    def store
      @store ||= Store.new(options && options[:store] || 'dugway')
    end

    def theme
      @theme ||= Theme.new(options && options[:customization] || {})
    end

    def cart
      @cart ||= Cart.new
    end

    def source_dir
      @source_dir ||= File.join(Dir.pwd, 'source')
    end
    
    def logger
      @logger ||= Logger.new
    end

    def options
      @options
    end
  end
end
