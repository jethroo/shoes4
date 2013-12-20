class Shoes
  module Swt
    class TextBlockCursorPainter
      def initialize(dsl, fitted_layouts)
        @dsl = dsl
        @fitted_layouts = fitted_layouts
      end

      def draw
        if @dsl.cursor
          draw_textcursor
        else
          remove_textcursor
        end
      end

      def draw_textcursor
        layout = choose_layout
        position = layout.get_location(relative_cursor)

        cursor = textcursor(layout.line_height)
        cursor.move(layout.left + position.x, layout.top + position.y)
        cursor.show
      end

      # Only works with one or two layouts, but that's what we've got
      # -1 should position us at the very end, regardless text length
      def choose_layout
        first_layout = @fitted_layouts.first
        last_layout = @fitted_layouts.last

        if cursor_fits_in?(@dsl.cursor, first_layout)
          first_layout
        else
          last_layout
        end
      end

      # Again, assumes one or two layout system
      def relative_cursor
        first_layout = @fitted_layouts.first
        last_layout = @fitted_layouts.last

        if cursor_fits_in?(@dsl.cursor, first_layout)
          @dsl.cursor
        elsif @dsl.cursor < 0 ||
              @dsl.cursor > (first_layout.text.length + last_layout.text.length)
          last_layout.text.length
        else
          @dsl.cursor - first_layout.text.length
        end
      end

      def cursor_fits_in?(cursor, layout)
        cursor <= layout.text.length && cursor >= 0
      end

      def textcursor(line_height)
        @dsl.textcursor ||= @dsl.app.line(0, 0, 0, line_height, hidden: true,
                                          strokewidth: 1, stroke: @dsl.app.black)
      end

      def remove_textcursor
        return unless @dsl.textcursor

        @dsl.textcursor.remove
        @dsl.textcursor = nil
      end
    end
  end
end
