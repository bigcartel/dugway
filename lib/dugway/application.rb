module Dugway
  class Application
    def initialize(options={})
      @theme = Theme.new(options[:user_settings] || {})
      @store = Store.new(options[:store] || 'dugway')
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
