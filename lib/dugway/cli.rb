require 'thor'
require 'active_support/all'

require 'dugway'
require 'dugway/cli/build'
require 'dugway/cli/create'
require 'dugway/cli/server'
require 'dugway/cli/validate'

module Dugway
  module Cli
    class Base < Thor
      register Create, 'create', 'create', 'Create a new Big Cartel theme'
      register Build, 'build', 'build', 'Build your Big Cartel theme for use'
      register Server, 'server', 'server', 'Run your Big Cartel theme in the browser'
      register Validate, 'validate', 'validate', 'Validate your Big Cartel theme'

      desc 'version', 'Show version of Dugway'
      def version
        say "Dugway #{ Dugway::VERSION }"
      end
    end
  end
end
