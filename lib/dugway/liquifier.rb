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
    def initialize(request)
      @request = request
    end

    def render(content, variables={})
      variables.symbolize_keys!

      assigns = shared_assigns
      assigns['page_content'] = variables[:page_content]
      assigns['page'] = Drops::PageDrop.new(variables[:page])
      assigns['product'] = Drops::ProductDrop.new(variables[:product])

      registers = shared_registers
      registers[:category] = variables[:category]
      registers[:artist] = variables[:artist]

      if errors = variables.delete(:errors)
        shared_context['errors'] << errors
      end

      context = Liquid::Context.new([ assigns, shared_context ], {}, registers)
      Liquid::Template.parse(content).render!(context)
    end

    def self.render_styles(css)
      Liquid::Template.parse(css).render!(
        { 'theme' => Drops::ThemeDrop.new(Dugway.theme.customization) },
        :registers => { :settings => Dugway.theme.settings }
      )
    end

    private

    def store
      Dugway.store
    end

    def theme
      Dugway.theme
    end

    def cart
      Dugway.cart
    end

    def shared_context
      @shared_context ||= { 'errors' => [] }
    end

    def shared_assigns
      {
        'store' => Drops::AccountDrop.new(store.account),
        'cart' => Drops::CartDrop.new(cart),
        'theme' => Drops::ThemeDrop.new(theme.customization),
        'pages' => Drops::PagesDrop.new(store.pages.map { |p| Drops::PageDrop.new(p) }),
        'categories' => Drops::CategoriesDrop.new(store.categories.map { |c| Drops::CategoryDrop.new(c) }),
        'artists' => Drops::ArtistsDrop.new(store.artists.map { |a| Drops::ArtistDrop.new(a) }),
        'products' => Drops::ProductsDrop.new(store.products.map { |p| Drops::ProductDrop.new(p) }),
        'contact' => Drops::ContactDrop.new,
        'head_content' => head_content,
        'bigcartel_credit' => bigcartel_credit
      }
    end

    def shared_registers
      {
        :request => @request,
        :path => @request.path,
        :params => @request.params.with_indifferent_access,
        :currency => store.currency,
        :settings => theme.settings
      }
    end

    def head_content
      content = %{<meta name="generator" content="Big Cartel">}

      if google_font_url = ThemeFont.google_font_url_for_theme
        content << %{\n<link rel="stylesheet" type="text/css" href="#{ google_font_url }">}
      end

      content
    end

    def bigcartel_credit
      '<a href="http://bigcartel.com/" title="Start your own store at Big Cartel now">Online Store by Big Cartel</a>'
    end
  end
end
