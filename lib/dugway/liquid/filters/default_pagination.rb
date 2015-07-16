module Dugway
  module Filters
    module DefaultPagination
      def default_pagination(paginate, div_id = 'pagination', div_class = 'pagination', prev_label = nil, next_label = nil)
        Array.new.tap { |html|
          html << %(<div class="#{ div_class }" id="#{ div_id }">)

          prev_label = prev_label.blank? ? paginate['previous']['title'] : prev_label
          if paginate['previous']['is_link']
            html << %(<a class="previous" href="#{ paginate['previous']['url'] }">#{ prev_label }</a>)
          else
            html << %(<span class="previous disabled">#{ prev_label }</span>)
          end

          paginate['parts'].each do |part|
            if part['is_link']
              html << %(<a href="#{ part['url'] }">#{ part['title'] }</a>)
            else
              html << %(<span class="#{ part['title'] == paginate['current_page'].to_s ? 'current' : 'gap' }">#{ part['title'] }</span>)
            end
          end

          next_label = next_label.blank? ? paginate['next']['title'] : next_label
          if paginate['next']['is_link']
            html << %(<a class="next" href="#{ paginate['next']['url'] }">#{ next_label }</a>)
          else
            html << %(<span class="next disabled">#{ next_label }</span>)
          end

          html << %(</div>)
        }.join(' ')
      end
    end
  end
end
