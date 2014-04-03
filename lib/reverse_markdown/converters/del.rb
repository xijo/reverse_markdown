module ReverseMarkdown
  module Converters
    class Del < Base
      def convert(node)
        content = treat_children(node)
        if disabled? || content.strip.empty? || already_crossed_out?(node)
          content
        else
          "~~#{content}~~"
        end
      end

      def enabled?
        ReverseMarkdown.config.github_flavored
      end

      def disabled?
        !enabled?
      end

      def already_crossed_out?(node)
        node.ancestors('del').size > 0 || node.ancestors('strike').size > 0
      end
    end

    register :strike, Del.new
    register :del,    Del.new
  end
end
