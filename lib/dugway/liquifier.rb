require 'liquid'
require "#{ File.dirname(__FILE__) }/liquid/drops/base_drop"
Dir.glob("#{ File.dirname(__FILE__) }/liquid/**/*.rb").each { |file| require file }

Liquid::Template.register_filter(Dugway::Filters::UtilFilters)
Liquid::Template.register_filter(Dugway::Filters::CoreFilters)
Liquid::Template.register_filter(Dugway::Filters::DefaultPagination)
Liquid::Template.register_filter(Dugway::Filters::UrlFilters)
Liquid::Template.register_filter(Dugway::Filters::FontFilters)
Liquid::Template.register_filter(Dugway::Filters::InstantCheckoutFilter)

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
      registers[:account] = Dugway.store

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
        'head_content' => [window_bigcartel_script, head_content].join,
        'bigcartel_credit' => bigcartel_credit,
        'powered_by_big_cartel' => powered_by_big_cartel,
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

      if google_font_url = ThemeFont.google_font_url_for_theme(Dugway.theme.fonts, Dugway.theme.customization)
        content << %{\n<link rel="stylesheet" type="text/css" href="#{ google_font_url }">}
      end

      content
    end

    def window_bigcartel_script
      product = @request.params[:product] ? store.product(@request.params[:product]) : nil

      script = "window.bigcartel = window.bigcartel || {};"
      script << "\nwindow.bigcartel.product = #{product.to_json};" if product

      "<script>#{script}</script>"
    end

    def bigcartel_credit
      '<a href="http://bigcartel.com/" title="Start your own store at Big Cartel now">Online Store by Big Cartel</a>'
    end

    def powered_by_big_cartel
      %(<a class="bigcartel-credit" href="https://www.bigcartel.com/?utm_source=bigcartel&utm_medium=storefront&utm_campaign=123" title="Powered by Big Cartel">
        <span class="bigcartel-credit__text" aria-hidden="true">Powered by</span>
        <svg aria-hidden="true" class="bigcartel-credit__lockup" xmlns="http://www.w3.org/2000/svg" viewBox="1.99 2.05 124.96 24.95">
          <path d="M46.18 4A1.91 1.91 0 1 1 50 4a1.91 1.91 0 1 1-3.81 0Zm78.76 14.35a.81.81 0 0 1-.25-.69V2.23h-4.52v2.68h1.58V18c0 2.14 1.11 3.28 3.2 3.28a6.56 6.56 0 0 0 2-.42v-2.78c-1.28.51-1.8.38-2.01.23Zm-75.27.05h1.43V21h-5.79v-2.64h1.43v-8h-1.61V7.7h4.54Zm-11.09-11a5.81 5.81 0 0 0-4.36 1.87V2.23H29.7v2.68h1.62v12.71a.81.81 0 0 1-.25.69c-.43.33-1.5 0-2.06-.23v2.76a6.59 6.59 0 0 0 2.05.42 2.92 2.92 0 0 0 2.74-1.32 6.86 6.86 0 0 0 4.27 1.34 6.66 6.66 0 0 0 6.86-7c-.01-4.06-2.68-6.97-6.35-6.97ZM38 18.57c-2.15 0-3.72-1.75-3.72-4.17s1.55-4.32 3.78-4.32a3.75 3.75 0 0 1 3.75 4.1c.02 2.55-1.58 4.39-3.81 4.39Zm68.86-.49v2.76a7.52 7.52 0 0 1-2 .42c-2.09 0-3.2-1.14-3.2-3.28V5.36l2.93-1.92V7.7h3.81l-1.91 2.68h-1.9v7.24a.77.77 0 0 0 .26.69c.53.4 2.03-.23 2.03-.23ZM58 7.31c-3.88 0-6.69 3-6.69 7.11s2.66 6.87 6.33 6.87A6.14 6.14 0 0 0 62 19.45v1.42c0 2.72-2.4 3.45-3.83 3.45a5.22 5.22 0 0 1-3.12-1.06l-2.36 1.83A7.78 7.78 0 0 0 58 27c3.21 0 6.95-1.63 6.95-6.21v-6.38A6.84 6.84 0 0 0 58 7.31Zm.12 11.29c-2.19 0-3.72-1.74-3.72-4.23s1.6-4.21 3.8-4.21a3.94 3.94 0 0 1 3.8 4.21 4 4 0 0 1-3.85 4.23ZM120.6 15c0-5.05-3.45-7.69-6.85-7.69a6.76 6.76 0 0 0-6.58 7.06 7.13 7.13 0 0 0 12.69 4.39l-2.22-1.71a4.24 4.24 0 0 1-3.44 1.69 3.86 3.86 0 0 1-3.94-3.11h10.28a3.09 3.09 0 0 0 .06-.63Zm-10.35-2.08a3.65 3.65 0 0 1 3.56-3.11 3.77 3.77 0 0 1 3.77 3.11ZM94.92 10V7.7h-4v2.68h1.62v8h-2.35a.83.83 0 0 1-.61-.19.91.91 0 0 1-.19-.64v-5.77c0-1.31-.65-4.47-5.52-4.47a7.85 7.85 0 0 0-4.14 1.18l1.17 2.23a5 5 0 0 1 3-.78 3.26 3.26 0 0 1 1.76.49 2.08 2.08 0 0 1 .81 1.78v1.25a6.58 6.58 0 0 0-3.21-.92c-2.58 0-3.91 1.62-5.19 3.2s-2.51 3-5 2.92c-2.27-.11-3.63-1.86-3.63-4.43 0-2.39 1.45-4 3.54-4a3.75 3.75 0 0 1 3.7 3.18l2.45-1.9a6.3 6.3 0 0 0-6.3-4.18 6.72 6.72 0 0 0-6.48 7c0 3.43 2.1 7.16 6.62 7.16a7.45 7.45 0 0 0 5.87-2.73 4.38 4.38 0 0 0 4.08 2.57 5.91 5.91 0 0 0 3.93-1.66 2.87 2.87 0 0 0 2.8 1.33h7.42v-2.64h-1.61v-3.21c0-3.3 1.09-4.77 3.56-4.77a3.68 3.68 0 0 1 1.45.31V8a4.81 4.81 0 0 0-1.74-.25A4.21 4.21 0 0 0 94.92 10Zm-8.47 7.48a4.93 4.93 0 0 1-3.16 1.41 1.9 1.9 0 0 1-2.05-1.91 2 2 0 0 1 2.18-2 5 5 0 0 1 3 1.18ZM11 14.52v-.89a1.78 1.78 0 0 1 .83-1.51l7.35-4.7A1.79 1.79 0 0 0 20 5.91V2.05L11 7.8 2 2.05V14.2a8.69 8.69 0 0 0 3.88 7.58L11 25.05l5.12-3.27A8.69 8.69 0 0 0 20 14.2V8.77Z" class="a"></path>
        </svg>
      </a>)
    end
  end
end
