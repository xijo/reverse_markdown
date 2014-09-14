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

      private

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
        text = remove_border_newlines(node.text)
        text = remove_inner_newlines(text)
        escape_keychars text
      end

      def remove_border_newlines(text)
        text.gsub(/\A\n+/, '').gsub(/\n+\z/, '')
      end

      def remove_inner_newlines(text)
        text.tr("\n\t", ' ').squeeze(' ')
      end
    end

    register :text, Text.new
  end
end
