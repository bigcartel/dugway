module BigCartel
  module Builder
    class Template
      def initialize(content, layout=nil)
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
        {}
      end
      
      def registers
        {}
      end
    end
  end
end
