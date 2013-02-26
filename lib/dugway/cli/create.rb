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
      
      class_option 'skip-bundle',
        :type    => :boolean,
        :default => false,
        :desc    => "Don't run bundle install"
      
      def self.source_root
        File.join(File.dirname(__FILE__), 'templates')
      end
      
      def core
        template('Gemfile.tt', "#{ theme_dir }/Gemfile")
        template('config.tt', "#{ theme_dir }/config.ru")
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
          copy_file('gitignore.tt', "#{ theme_dir }/.gitignore")
        end
      end
      
      def bundle
        unless options['skip-bundle']
          inside theme_dir, {} do
            run('bundle install --without development test')
          end
        end
      end

      def done
        say("#{ name } is ready!", :blue)
      end
      
      private
      
      def theme_dir
        name.parameterize
      end
      
      def source_dir
        "#{ theme_dir }/source"
      end
    end
  end
end
