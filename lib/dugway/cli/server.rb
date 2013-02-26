require 'rack'

module Dugway
  module Cli
    class Server < Thor::Group
      include Thor::Actions
      
      class_option :host,
        :type    => :string,
        :aliases => '-h',
        :default => '0.0.0.0',
        :desc    => 'The host address to bind to'
      
      class_option :port,
        :type    => :numeric,
        :aliases => '-p',
        :default => 9292,
        :desc    => "The port address to bind to"

      class_option :daemonize,
        :type    => :boolean,
        :aliases => '-d',
        :default => false,
        :desc    => "Run daemonized in the background"
      
      def start
        Rack::Server.start({
          :config => File.join(Dir.pwd, 'config.ru'),
          :environment => 'none',
          :Host => options[:host],
          :Port => options[:port],
          :daemonize => options[:daemonize]
        })
      end
    end
  end
end
