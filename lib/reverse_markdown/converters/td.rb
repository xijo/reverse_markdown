module ReverseMarkdown
  module Converters
    class Td < Base
      def convert(node, state = {})
        # A table row is one line: keep line breaks inside the cell as <br>
        content = treat_children(node, state.merge(table_cell: true)).strip.gsub(/\s*\n\s*/, '<br>')
        # A | in a cell would end it; code spans escape their own (GFM honours \| there too)
        " #{content.gsub('|', '\|')} |"
      end
    end

    register :td, Td.new
    register :th, Td.new
  end
end
