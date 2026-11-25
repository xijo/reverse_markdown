module ReverseMarkdown
  module Converters
    class Code < Base
      def convert(node, state = {})
        text = state[:table_cell] ? node.text.gsub('|', '\|') : node.text
        preserve_literal("`#{text}`", state)
      end
    end

    register :code, Code.new
  end
end
