module Dugway
  module Cli
    class Validate < Thor::Group
      include Thor::Actions

      class_option 'skip-color-validation',
        type: :boolean,
        default: false,
        desc: "Skip color settings validation"

      def validate
        unless theme.valid?(validate_colors: !options['skip-color-validation'])
          theme.errors.each { |error| say(error, :red) }
          say("\nTheme is invalid", :red)
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
