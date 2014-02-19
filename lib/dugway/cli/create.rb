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
        template('source/settings.coffee', "#{ source_dir }/settings.coffee")
      end

      def source
        unless options['skip-source']
          Dir.glob("#{ self.class.source_root }/source/**/*.{html,jpg,png,js,coffee,css,sass}") do |file|
            file_name = file.gsub("#{ self.class.source_root }/source/", '')
            next if file_name =~ /settings.coffee/
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
