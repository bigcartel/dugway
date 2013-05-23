# Set our encodings to ensure we're always dealing with UTF-8 data.
# Users experiencing problems with their templates should ensure they are saved as UTF-8.
old_verbose, $VERBOSE = $VERBOSE, nil
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
$VERBOSE = old_verbose

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

      I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'dugway', 'data', 'locales', '*.yml').to_s]
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
