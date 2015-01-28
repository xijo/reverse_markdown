module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node)
        if ReverseMarkdown.config.github_flavored
          "\n```#{extract_language(node)}\n" << node.text.strip << "\n```\n"
        else
          "\n\n    " << node.text.strip.lines.to_a.join("    ") << "\n\n"
        end
      end

      private

      def extract_language(node)
        ReverseMarkdown.config.github_flavored or return
        css_class = node.parent['class'].to_s
        css_class[/highlight-([a-zA-Z0-9]+)/, 1]
      end
    end

    register :pre, Pre.new
  end
end
