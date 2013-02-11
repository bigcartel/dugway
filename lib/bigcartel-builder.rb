require 'active_support/all'

require 'bigcartel-builder/application'
require 'bigcartel-builder/liquifier'
require 'bigcartel-builder/request'
require 'bigcartel-builder/store'
require 'bigcartel-builder/template'
require 'bigcartel-builder/theme'

module BigCartel
  module Builder
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
      @logger ||= Logger.new(File.join(Dir.pwd, 'log', 'builder.log'))
    end
  end
end
