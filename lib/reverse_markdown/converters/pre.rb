module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node, state = {})
        content = treat_children(node, state).strip
        if ReverseMarkdown.config.github_flavored
          code = "```#{language(node)}\n#{content}\n```"
          "\n#{preserve_literal(code, state)}\n"
        else
          code = "    #{content.lines.to_a.join('    ')}"
          "\n\n#{preserve_literal(code, state)}\n\n"
        end
      end

      private

      # Highlighting wrappers are not prose: recurse without normalizing or
      # escaping their text, while preserving explicit HTML line breaks.
      def treat(node, state)
        if node.text? || node.cdata?
          node.text
        elsif node.name == 'br'
          "\n"
        else
          treat_children(node, state)
        end
      end

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
