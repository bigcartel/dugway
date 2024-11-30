require 'zip/zip'

module Dugway
  module Cli
    class Build < Thor::Group
      include Thor::Actions

      class_option 'skip-color-validation',
        type: :boolean,
        default: false,
        desc: "Skip color settings validation"

      def self.source_root
        File.join(Dir.pwd, 'source')
      end

      def self.destination_root
        File.join(Dir.pwd, 'build')
      end

      def validate
        unless theme.valid?(validate_colors: !options['skip-color-validation'])
          theme.errors.each { |error| say(error, :red) }
          say("\nTheme is invalid", :red)
          exit(1)
        end
      end

      def create_destination
        empty_directory self.class.destination_root
      end

      def build
        Zip::ZipFile.open(build_file, Zip::ZipFile::CREATE) do |zipfile|
          theme.files.each do |file|
            zipfile.get_output_stream(file) do |f|
              f << theme.build_file(file)
            end
          end
        end
      end

      def success
        say_status(:create, "build/#{ build_name }")
      end

      private

      def theme
        @theme ||= Dugway.theme
      end

      def build_name
        @build_name ||= "#{ theme.name.parameterize }-#{ theme.version }.zip"
      end

      def build_file
        @build_file ||= File.join(self.class.destination_root, build_name)
      end
    end
  end
end
