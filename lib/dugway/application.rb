module Dugway
  class Application
    def initialize(options={})
      @theme = Theme.new(File.join(Dir.pwd, 'source'), options[:customization] || {})
      @store = Store.new(options[:store] || 'dugway')
      
      I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'data', 'locales', '*.yml').to_s]
      I18n.default_locale = 'en-US'
      I18n.locale = @store.locale
    end
    
    def call(env)
      request = Request.new(env)
      
      if request.image?
        @theme.find_image_by_env(env)
      elsif template = find_template(request)
        [200, { 'Content-Type' => template.content_type }, [template.render(@theme, @store, request)]]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['Page not found']]
      end
    end
    
    private
    
    def find_template(request)
      if template = @theme.find_template_by_request(request)
        template
      elsif page = @store.page(request.permalink)
        Template.new(request.file_name, page['content'])
      else
        nil
      end
    end
  end
end
