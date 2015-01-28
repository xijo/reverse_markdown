module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node)
        if ReverseMarkdown.config.github_flavored
          highlight_match = node.parent['class'].nil? ? nil : node.parent['class'].match(/highlight highlight-([a-zA-Z0-9]+)/)
          language_string = highlight_match ? highlight_match[1] : ''
          '```' << language_string << "\n" << node.text.strip << "\n```\n"
        else
          "\n\n    " << node.text.strip.lines.to_a.join("    ") << "\n\n"
        end
      end
    end

    register :pre, Pre.new
  end
end
