require 'thor'

require 'dugway/cli/create'
require 'dugway/version'

module Dugway
  module Cli
    class Base < Thor
      register Create, 'create', 'create', 'Creates a new Big Cartel theme'
      
      desc 'version', 'Show version of Dugway'
      def version
        say "Dugway #{ Dugway::VERSION }"
      end
    end
  end
end
