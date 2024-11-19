require 'rack'
require 'listen'

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

      class_option :suppress_warnings,
        type: :boolean,
        aliases: '-q',
        default: false,
        desc: "Suppress warnings"

      def start
        if options[:suppress_warnings]
          $VERBOSE = nil
        end

        listener = Listen.to('.', only: /\.dugway\.json$/) do |modified|
          puts "Config changed, restarting server..."
          exec "dugway server"
        end

        Thread.new { listener.start }

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
