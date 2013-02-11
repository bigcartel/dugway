module BigCartel
  module Builder
    class Template
      def initialize(store, settings, content, layout=nil)
        @store = store
        @settings = settings
        @content = content
        @layout = layout
      end
      
      def render
        if standalone?
          render_liquid @content
        else
          render_liquid @layout, :page_content => @content
        end
      end
      
      def standalone?
        @layout.nil? || @content =~ /\{\{\s*page_content\s*\}\}/ ? true : false
      end
      
      private
      
      def render_liquid(content, additional_assigns={})
        Liquid::Template.parse(content).render(assigns.update(additional_assigns), :registers => registers)
      end
      
      def assigns
        {
          'errors' => [],
          'store' => AccountDrop.new(@store.account),
          'cart' => CartDrop.new,
          'theme' => ThemeDrop.new(@settings),
          # 'page' => PageDrop.new(@page),
          # 'product' => ProductDrop.new(@product),
          'pages' => PagesDrop.new(@store.pages.map { |p| PageDrop.new(p) }),
          'categories' => CategoriesDrop.new(@store.categories.map { |c| CategoryDrop.new(c) }),
          'artists' => ArtistsDrop.new(@store.artists.map { |a| ArtistDrop.new(a) }),
          'products' => ProductsDrop.new(@store.products.map { |p| ProductDrop.new(p) }),
          'contact' => ContactDrop.new,
          'head_content' => '<meta name="generator" content="Big Cartel" />'
        }
      end

      def registers
        {
          # :params => @params,
          # :full_url => @page.full_url,
          # :path => @page.url,
          # :currency => assigns['store'].currency,
          # :settings => @settings,
          # :category => @category,
          # :artist => @artist
        }
      end
    end
  end
end
