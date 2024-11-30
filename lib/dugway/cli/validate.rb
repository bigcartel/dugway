module Dugway
  module Cli
    class Validate < Thor::Group
      include Thor::Actions

      def validate
        unless theme.valid?
          theme.errors.each { |error| say(error, :red) }
          exit(1)
        end
        say("Theme is valid!", :green)
      end

      private

      def theme
        @theme ||= Dugway.theme
      end
    end
  end
end
