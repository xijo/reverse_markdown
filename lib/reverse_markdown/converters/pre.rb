module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node)
        if ReverseMarkdown.config.github_flavored
          "\n```#{language(node)}\n" << node.text.strip << "\n```\n"
        else
          "\n\n    " << node.text.strip.lines.to_a.join("    ") << "\n\n"
        end
      end

      private

      def language(node)
        lang = language_from_highlight_class(node)
        lang || language_from_confluence_class(node)
      end

      def language_from_highlight_class(node)
        node.parent['class'].to_s[/highlight-([a-zA-Z0-9]+)/, 1]
      end

      def language_from_confluence_class(node)
        node['class'].to_s[/brush:\s?(:?.*);/, 1]
      end
    end

    register :pre, Pre.new
  end
end
