module ReverseMarkdown
  module Converters
    class Li < Base
      def convert(node, state = {})
        contains_child_paragraph = node.first_element_child ? node.first_element_child.name == 'p' : false
        content                  = treat_children(node, state)
        content                  = content.sub(/\A[ \t]*\n\n/, '') if contains_child_paragraph
        prefix                   = prefix_for(node)
        content                  = content.lines.map.with_index do |line, index|
          index.zero? || line.strip.empty? ? line : "#{' ' * prefix.length}#{line}"
        end.join

        "#{prefix}#{content.chomp}\n" +
          (contains_child_paragraph ? "\n" : '')
      end

      def prefix_for(node)
        if node.parent.name == 'ol'
          index = node.parent.xpath('li').index(node)
          "#{index.to_i + 1}. "
        else
          '- '
        end
      end
    end

    register :li, Li.new
  end
end
