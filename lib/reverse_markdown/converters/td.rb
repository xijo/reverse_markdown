module ReverseMarkdown
  module Converters
    class Td < Base
      def convert(node, state = {})
        # A table row is one line: keep line breaks inside the cell as <br>
        content = treat_children(node, state).strip.gsub(/\s*\n\s*/, '<br>')
        " #{content} |"
      end
    end

    register :td, Td.new
    register :th, Td.new
  end
end
