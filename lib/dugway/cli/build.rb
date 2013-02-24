require 'zip/zip'

module Dugway
  module Cli
    class Build < Thor::Group
      include Thor::Actions
      
      def self.source_root
        File.join(Dir.pwd, 'source')
      end
      
      def self.destination_root
        File.join(Dir.pwd, 'builds')
      end
      
      def validate
        error = false
        
        Theme::REQUIRED_FILES.each { |file|
          begin
            find_in_source_paths(file)
          rescue
            say("You're missing #{ file }", :red)
            error = true
          end
        }
        
        raise 'Missing required files' if error
      end
      
      def create_destination
        empty_directory self.class.destination_root
      end
      
      def build
        Zip::ZipFile.open(build_file, Zip::ZipFile::CREATE) { |zipfile|
          Theme::REQUIRED_FILES.each { |file|
            zipfile.get_output_stream(file) { |f|
              f << theme.build_file(file)
            }
          }
        }
      end
      
      def success
        say_status(:create, "builds/#{ build_name }")
      end
      
      private
      
      def theme
        @theme ||= Theme.new(self.class.source_root)
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
