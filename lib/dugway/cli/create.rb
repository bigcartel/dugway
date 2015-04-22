module Dugway
  module Cli
    class Create < Thor::Group
      include Thor::Actions

      argument :name

      class_option 'skip-source',
        :type    => :boolean,
        :default => false,
        :desc    => "Don't create a starter theme"

      class_option 'skip-git',
        :type    => :boolean,
        :default => false,
        :desc    => "Don't create a .gitignore file"

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates')
      end

      def variables
        @name = name.titleize
        @theme_dir = name.parameterize
      end

      def core
        template('config.tt', "#{ @theme_dir }/config.ru")
        template('dugway.tt', "#{ @theme_dir }/.dugway.json")
        template('source/settings.json', "#{ source_dir }/settings.json")
      end

      def source
        unless options['skip-source']
          Dir.glob("#{ self.class.source_root }/source/**/*.{html,jpg,png,js,coffee,css,sass}") do |file|
            file_name = file.gsub("#{ self.class.source_root }/source/", '')
            copy_file "source/#{ file_name }", "#{ source_dir }/#{ file_name }"
          end
        end
      end

      def git
        unless options['skip-git']
          copy_file('gitignore.tt', "#{ @theme_dir }/.gitignore")
        end
      end

      def done
        say("#{ name } is ready!", :blue)
      end

      private

      def source_dir
        "#{ @theme_dir }/source"
      end
    end
  end
end
