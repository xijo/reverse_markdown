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

      INLINE_ELEMENTS = [:a, :abbr, :b, :bdi, :bdo, :cite, :code, :data, :del,
                          :dfn, :em, :i, :ins, :kbd, :mark, :q, :rp, :rt, :ruby,
                          :s, :samp, :small, :span, :strong, :sub, :sup, :time,
                          :u, :var, :wbr, :font, :tt].freeze

      def treat_empty(node)
        parent = node.parent.name.to_sym
        if [:ol, :ul].include?(parent)  # Otherwise the identation is broken
          ''
        elsif node.text == ' '          # Regular whitespace text node
          ' '
        elsif INLINE_ELEMENTS.include?(parent) && node.text =~ /\n/
          # Preserve newlines between inline elements as space (HTML whitespace collapsing)
          ' '
        else
          ''
        end
      end

      def treat_text(node)
        text = node.text
        text = preserve_nbsp(text)
        text = remove_border_newlines(text, node)
        text = remove_inner_newlines(text)
        text = escape_keychars(text)

        text = preserve_keychars_within_backticks(text)
        text = preserve_tags(text)

        text
      end

      def preserve_nbsp(text)
        text.gsub(/\u00A0/, "&nbsp;")
      end

      def preserve_tags(text)
        text.gsub(/[<>]/, '>' => '\>', '<' => '\<')
      end

      def remove_border_newlines(text, node)
        result = text.gsub(/\A\n+/, '')
        # Only convert trailing newlines to space if there's following inline content
        # This handles HTML whitespace collapsing between inline elements
        if has_following_inline_content?(node)
          result.gsub(/\n+\z/, ' ')
        else
          result.gsub(/\n+\z/, '')
        end
      end

      def has_following_inline_content?(node)
        # Check if node has a following sibling that is inline content
        sibling = node.next_sibling
        while sibling
          if sibling.text?
            return true unless sibling.text.strip.empty?
          elsif INLINE_ELEMENTS.include?(sibling.name.to_sym)
            return true
          else
            # Block element - no space needed before it
            return false
          end
          sibling = sibling.next_sibling
        end

        # Recursively check if inline parent has following content
        parent = node.parent
        return false unless INLINE_ELEMENTS.include?(parent.name.to_sym)

        has_following_inline_content?(parent)
      end

      def remove_inner_newlines(text)
        text.tr("\r\n\t", ' ').squeeze(' ')
      end

      def preserve_keychars_within_backticks(text)
        text.gsub(/`.*?`/) do |match|
          match.gsub('\_', '_').gsub('\*', '*')
        end
      end
    end

    register :text, Text.new
  end
end
