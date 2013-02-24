require 'yaml'

module Dugway
  class ThemeFont < Struct.new(:name, :family, :collection)
    class << self
      def all
        @@all ||= Array.new.tap { |fonts|
          source.each_pair { |collection, collection_fonts|
            collection_fonts.values.each { |font|
              fonts << ThemeFont.new(font[:name], font[:family], collection)
            }
          }
        }.sort_by { |font| font.name }
      end

      def options
        @@options ||= all.map(&:name)
      end

      def find_by_name(name)
        all.find { |font|
          name.downcase == font.name.downcase
        }
      end

      def find_family_by_name(name)
        if font = find_by_name(name)
          font.family
        else
          name
        end
      end

      def google_font_names
        @@google_font_names ||= all.select { |font| 
          font.collection == 'google' 
        }.map(&:name)
      end

      def google_font_url_for_fonts(fonts)
        "//fonts.googleapis.com/css?family=#{ fonts.map { |font| font.gsub(' ', '+') }.join('|') }"
      end

      def google_font_url_for_all_fonts
        google_font_url_for_fonts(google_font_names)
      end

      def google_font_url_for_theme_instance(theme)
        fonts = theme.fonts.keys.map { |key|
          theme.customization[key] }.select { |font_name|
            google_font_names.include? font_name }.sort

        if fonts.present?
          google_font_url_for_fonts(fonts)
        else
          nil
        end
      end

      private

      def source
        @@source ||= HashWithIndifferentAccess.new(YAML.load(File.read(File.join(File.dirname(__FILE__), 'data', 'theme_fonts.yml'))))
      end
    end
  end
end
