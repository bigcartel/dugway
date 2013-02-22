require 'liquid'
require "#{ File.dirname(__FILE__) }/liquid/drops/base_drop"
Dir.glob("#{ File.dirname(__FILE__) }/liquid/**/*.rb").each { |file| require file }

Liquid::Template.register_filter(UtilFilters)
Liquid::Template.register_filter(CoreFilters)
Liquid::Template.register_filter(DefaultPagination)
Liquid::Template.register_filter(UrlFilters)

Liquid::Template.register_tag(:checkoutform, CheckoutForm)
Liquid::Template.register_tag(:get, Get)
Liquid::Template.register_tag(:paginate, Paginate)

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
      ass = restrict_to_theme ? assigns.slice('theme') : assigns.update(overridden_assigns)
      reg = restrict_to_theme ? {} : registers
      Liquid::Template.parse(content).render(ass, :registers => reg)
    end
    
    private
    
    def assigns
      {
        'errors' => [],
        'store' => AccountDrop.new(@store.account),
        'cart' => CartDrop.new,
        'theme' => ThemeDrop.new(@theme.user_settings),
        'page' => PageDrop.new(@page),
        'product' => ProductDrop.new(@product),
        'pages' => PagesDrop.new(@store.pages.map { |p| PageDrop.new(p) }),
        'categories' => CategoriesDrop.new(@store.categories.map { |c| CategoryDrop.new(c) }),
        'artists' => ArtistsDrop.new(@store.artists.map { |a| ArtistDrop.new(a) }),
        'products' => ProductsDrop.new(@store.products.map { |p| ProductDrop.new(p) }),
        'contact' => ContactDrop.new,
        'head_content' => '<meta name="generator" content="Big Cartel" />',
        'bigcartel_credit' => '<a href="http://bigcartel.com/" title="Start your own store at Big Cartel now">Online Store by Big Cartel</a>'
      }
    end

    def registers
      {
        :params => @request.params.with_indifferent_access,
        :full_url => @request.url,
        :full_path => @request.fullpath,
        :path => @request.path,
        :currency => @store.currency,
        :settings => @theme.user_settings,
        :category => @category,
        :artist => @artist
      }
    end
  end
end
