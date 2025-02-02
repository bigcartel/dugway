module Dugway
  module Cli
    class Validate < Thor::Group
      include Thor::Actions

      class_option 'skip-color-validation',
        type: :boolean,
        default: false,
        desc: "Skip color settings validation"

      class_option 'skip-layout-attribute-validation',
        type: :boolean,
        default: false,
        desc: "Skip layout file data attribute validation"

      class_option 'skip-options-validation',
        type: :boolean,
        default: false,
        desc: "Skip options validation"

      def validate
        validation_options = {
          validate_colors: !options['skip-color-validation'],
          validate_layout_attributes: !options['skip-layout-attribute-validation'],
          validate_options: !options['skip-options-validation']
        }

        unless theme.valid?(**validation_options)
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
