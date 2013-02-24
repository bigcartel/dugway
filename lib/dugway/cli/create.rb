module Dugway
  module Cli
    class Create < Thor::Group
      include Thor::Actions
      
      argument :name
      
      class_option 'skip-theme',
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
      end
      
      def settings
        template('theme/settings.json', "#{ source_dir }/settings.json")
      end
      
      def theme
        unless options['skip-theme']
          Dir.glob("#{ self.class.source_root }/theme/**/*.{html,jpg,png,js,coffee,css,sass,scss}") do |file|
            file_name = file.gsub("#{ self.class.source_root }/theme/", '')
            copy_file "theme/#{ file_name }", "#{ source_dir }/#{ file_name }"
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
          #run('bundle install --without development test')
        end
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
