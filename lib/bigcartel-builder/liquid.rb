require 'liquid'
require "#{ File.dirname(__FILE__) }/liquid/drops/base_drop"
Dir.glob("#{ File.dirname(__FILE__) }/liquid/**/*.rb").each { |file| require file }

Liquid::Template.register_filter(UtilFilters)
Liquid::Template.register_filter(CoreFilters)
Liquid::Template.register_filter(DefaultPagination)
Liquid::Template.register_filter(PaginationFilters)
Liquid::Template.register_filter(UrlFilters)

Liquid::Template.register_tag(:checkoutform, CheckoutForm)
Liquid::Template.register_tag(:get, Get)
Liquid::Template.register_tag(:paginate, Paginate)
