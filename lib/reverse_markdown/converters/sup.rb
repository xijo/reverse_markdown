module ReverseMarkdown
  module Converters
    class Sup < Base
      def convert(node)
        content = treat_children(node)
        if content.strip.empty? || already_superscript?(node)
          content
        else
          "^(#{content})"
        end
      end

      def already_superscript?(node)
        node.ancestors('sup').size > 0
      end
    end

    register :sup, Sup.new
  end
end
