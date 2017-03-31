module ReverseMarkdown
  module Converters
    class Blockquote < Base
      def convert(node, state = {})
        content = treat_children(node, state).strip
        content = ReverseMarkdown.cleaner.remove_newlines(content)
        '> ' << content.lines.to_a.join('> ') << "\n\n"
      end
    end

    register :blockquote, Blockquote.new
  end
end
