module ReverseMarkdown
  module Converters
    class Text < Base
      def convert(node, options = {})
        if node.text.strip.empty?
          treat_empty(node)
        else
          treat_text(node)
        end
      end

      def treat_empty(node)
        parent = node.parent.name.to_sym
        if [:ol, :ul].include?(parent)  # Otherwise the identation is broken
          ''
        elsif node.text == ' '          # Regular whitespace text node
          ' '
        else
          ''
        end
      end

      def treat_text(node)
        escape_keychars node.text.tr("\n\t", '').squeeze(' ')
      end
    end

    register :text, Text.new
  end
end
