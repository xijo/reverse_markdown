module ReverseMarkdown
  module Highlighters
    class Base
      def highlight_code(node)
        ReverseMarkdown::Highlighters.lookup(ReverseMarkdown.config.syntax_highlight).highlight(node)
      end
    end
  end
end