module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node, state = {})
        if ReverseMarkdown.config.github_flavored
          "\n```#{language(node)}\n" << node.text.strip << "\n```\n"
        else
          treatedChildren = treat_children(node, state).strip
          treatedChildren = treatedChildren.chomp("`").reverse.chomp("`").reverse if treatedChildren[0] == "`" && treatedChildren[-1] == "`"
          "\n\n    " << treatedChildren.lines.to_a.join("    ") << "\n\n"
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
