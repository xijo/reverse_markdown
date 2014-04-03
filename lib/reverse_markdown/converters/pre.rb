require 'base64'

module ReverseMarkdown
  module Converters
    class Pre < Base
      def convert(node)
        if ReverseMarkdown.config.github_flavored
          "```\n" << node.text.strip << "\n```\n"
        else
          "\n\n    " << node.text.strip.lines.to_a.join("    ") << "\n\n"
        end
      end
    end

    register :pre, Pre.new
  end
end
