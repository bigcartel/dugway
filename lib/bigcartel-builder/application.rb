require 'rack/builder'

module BigCartel
  module Builder
    class Application < Rack::Builder
      IMAGE_PATH = /^\/images\/.+\.(jpg|jpeg|gif|png)$/
      
      def initialize(options={})
        @source_dir = File.join(Dir.pwd, options[:source_dir] || 'source')
        @theme = Theme.new(@source_dir, options[:user_settings] || {})
        @store = Store.new(options[:store] || 'builder')
      end
      
      def call(env)
        request = Rack::Request.new(env)
        
        if request.path =~ IMAGE_PATH
          Rack::File.new(@source_dir).call(env)
        elsif template = @theme.find_template_by_path(request.path)
          [200, { 'Content-Type' => template.content_type }, [template.render(@store, request)]]
        else
          [404, { 'Content-Type' => 'text/plain' }, ['Page not found']]
        end
      end
    end
  end
end
