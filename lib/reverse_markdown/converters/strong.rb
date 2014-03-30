module ReverseMarkdown
  module Converters
    class Strong < Base
      def convert(node)
        content = treat_children(node)
        if content.strip.empty? || already_strong?(node)
          content
        else
          "**#{content}**"
        end
      end

      def already_strong?(node)
        node.ancestors('strong').size > 0 || node.ancestors('b').size > 0
      end
    end

    register :strong, Strong.new
    register :b,      Strong.new
  end
end
