module Dugway
  module Filters
    module DefaultPagination
      def default_pagination(paginate, div_id = 'pagination', div_class = 'pagination', prev_label = nil, next_label = nil)
        Array.new.tap { |html|
          html << %(<div class="#{ div_class }" id="#{ div_id }">)

          prev_label = prev_label.blank? ? paginate['previous']['title'] : prev_label
          if paginate['previous']['is_link']
            html << %(<a class="previous" href="#{ paginate['previous']['url'] }" aria-label="Go to previous page">#{ prev_label }</a>)
          else
            html << %(<span class="previous disabled">#{ prev_label }</span>)
          end

          paginate['parts'].each do |part|
            if part['is_link']
              html << %(<a href="#{ part['url'] }" aria-label="Go to page #{part['title']}">#{ part['title'] }</a>)
            else
              html << build_non_link_span(part, paginate)
            end
          end

          next_label = next_label.blank? ? paginate['next']['title'] : next_label
          if paginate['next']['is_link']
            html << %(<a class="next" href="#{ paginate['next']['url'] }" aria-label="Go to next page">#{ next_label }</a>)
          else
            html << %(<span class="next disabled">#{ next_label }</span>)
          end

          html << %(</div>)
        }.join(' ')
      end

      private

      def build_non_link_span(part, paginate)
        is_current = is_current_page?(part, paginate)
        span_class = is_current ? 'current' : 'gap'

        span = %(<span )
        span << %(class="#{span_class}" )
        span << %(aria-label="Current page, page #{part['title']}") if is_current
        span << %(>)
        span << %(#{ part['title'] }</span>)
        span
      end

      def is_current_page?(part, paginate)
        part['title'] == paginate['current_page'].to_s
      end
    end
  end
end
