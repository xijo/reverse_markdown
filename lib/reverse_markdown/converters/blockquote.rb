module ReverseMarkdown
  module Converters
    class Blockquote < Base
      def convert(node)
        content = treat_children(node).strip
        content = ReverseMarkdown.cleaner.remove_newlines(content)
        '> ' << content.lines.join('> ')
      end
    end

    register :blockquote, Blockquote.new
  end
end
