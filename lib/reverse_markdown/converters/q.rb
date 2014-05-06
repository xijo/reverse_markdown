module ReverseMarkdown
  module Converters
    class Q < Base
      def convert(node)
        content = treat_children(node)
        if content.strip.empty? || already_quoted?(node)
          content
        else
          "\"#{content}\""
        end
      end

      def already_quoted?(node)
        node.ancestors('q').size > 0
      end
    end

    register :q, Q.new
  end
end
