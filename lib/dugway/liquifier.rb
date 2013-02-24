require 'liquid'
require "#{ File.dirname(__FILE__) }/liquid/drops/base_drop"
Dir.glob("#{ File.dirname(__FILE__) }/liquid/**/*.rb").each { |file| require file }

Liquid::Template.register_filter(Dugway::Filters::UtilFilters)
Liquid::Template.register_filter(Dugway::Filters::CoreFilters)
Liquid::Template.register_filter(Dugway::Filters::DefaultPagination)
Liquid::Template.register_filter(Dugway::Filters::UrlFilters)
Liquid::Template.register_filter(Dugway::Filters::FontFilters)

Liquid::Template.register_tag(:checkoutform, Dugway::Tags::CheckoutForm)
Liquid::Template.register_tag(:get, Dugway::Tags::Get)
Liquid::Template.register_tag(:paginate, Dugway::Tags::Paginate)

module Dugway
  class Liquifier
    def initialize(theme, store, request)
      @theme = theme
      @store = store
      @request = request
      
      if request.html?
        @page = @store.page(request.permalink)
        @page['url'] = request.path
        @page['full_url'] = request.url
        @page['full_path'] = request.fullpath
        
        if request.product_permalink && @product = @store.product(request.product_permalink)
          @page['name'] = @product['name']
        elsif request.category_permalink && @category = @store.category(request.category_permalink)
          @page['name'] = @category['name']
        elsif request.artist_permalink && @artist = @store.artist(request.artist_permalink)
          @page['name'] = @artist['name']
        end
      end
    end
    
    def render(content, overridden_assigns={}, restrict_to_theme=false)
      Liquid::Template.parse(content).render!(
        restrict_to_theme ? assigns.slice('theme') : assigns.update(overridden_assigns),
        :registers => registers
      )
    end
    
    private
    
    def assigns
      {
        'errors' => [],
        'store' => Drops::AccountDrop.new(@store.account),
        'cart' => Drops::CartDrop.new,
        'theme' => Drops::ThemeDrop.new(@theme.customization),
        'page' => Drops::PageDrop.new(@page),
        'product' => Drops::ProductDrop.new(@product),
        'pages' => Drops::PagesDrop.new(@store.pages.map { |p| Drops::PageDrop.new(p) }),
        'categories' => Drops::CategoriesDrop.new(@store.categories.map { |c| Drops::CategoryDrop.new(c) }),
        'artists' => Drops::ArtistsDrop.new(@store.artists.map { |a| Drops::ArtistDrop.new(a) }),
        'products' => Drops::ProductsDrop.new(@store.products.map { |p| Drops::ProductDrop.new(p) }),
        'contact' => Drops::ContactDrop.new,
        'head_content' => head_content,
        'bigcartel_credit' => bigcartel_credit
      }
    end
    
    def registers
      {
        :store => @store,
        :request => @request,
        :path => @request.path,
        :params => @request.params.with_indifferent_access,
        :currency => @store.currency,
        :category => @category,
        :artist => @artist,
        :settings => @theme.settings
      }
    end
    
    def head_content
      content = %{<meta name="generator" content="Big Cartel">}
      
      if google_font_url = ThemeFont.google_font_url_for_theme_instance(@theme)
        content << %{\n<link rel="stylesheet" type="text/css" href="#{ google_font_url }">}
      end
      
      content
    end
    
    def bigcartel_credit
      '<a href="http://bigcartel.com/" title="Start your own store at Big Cartel now">Online Store by Big Cartel</a>'
    end
  end
end
