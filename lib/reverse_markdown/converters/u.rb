module ReverseMarkdown
  module Converters
    class U < Base
      def convert(node)
        content = treat_children(node)
        if content.strip.empty? || already_underlined?(node)
          content
        else
          "_#{content}_"
        end
      end

      def already_underlined?(node)
        node.ancestors('u').size > 0
      end
    end

    register :u, U.new
  end
end
