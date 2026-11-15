module ReverseMarkdown
  module Converters
    class Code < Base
      def convert(node, state = {})
        preserve_literal("`#{node.text}`", state)
      end
    end

    register :code, Code.new
  end
end
