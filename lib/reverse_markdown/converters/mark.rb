module ReverseMarkdown
  module Converters
    class Mark < Base
      def convert(node)
        content = treat_children(node)
        if content.strip.empty? || already_highlighted?(node)
          content
        else
          "==#{content}=="
        end
      end

      def already_highlighted?(node)
        node.ancestors('mark').size > 0
      end
    end

    register :mark, Mark.new
  end
end
