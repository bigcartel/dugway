require 'rack'

module Dugway
  module Cli
    class Server < Thor::Group
      class_option :host,
        :type    => :string,
        :aliases => '-h',
        :default => '127.0.0.1',
        :desc    => 'The host address to bind to'

      class_option :port,
        :type    => :numeric,
        :aliases => '-p',
        :default => 9292,
        :desc    => "The port address to bind to"

      class_option :server,
        :type    => :string,
        :aliases => '-s',
        :default => 'thin',
        :desc    => "The server to run"

      def start
        Rack::Server.start({
          :config => File.join(Dir.pwd, 'config.ru'),
          :environment => 'none',
          :Host => options[:host],
          :Port => options[:port],
          :server => options[:server]
        })
      end
    end
  end
end
