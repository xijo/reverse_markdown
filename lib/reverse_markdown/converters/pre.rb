require 'base64'

module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node)
        if ReverseMarkdown.config.github_flavored
          "\n```#{lang(node)}\n" << node.text.strip << "\n```\n"
        else
          "\n\n    " << node.text.strip.lines.to_a.join("    ") << "\n\n"
        end
      end
      private
      def lang(node)
        ReverseMarkdown::Highlighters.lookup(ReverseMarkdown.config.syntax_highlight).highlight(node)
      end
    end

    register :pre, Pre.new
  end
end
