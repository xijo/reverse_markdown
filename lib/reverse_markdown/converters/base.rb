module ReverseMarkdown
  module Converters
    class Base
      def treat_children(node)
        node.children.inject('') do |memo, child|
          memo << treat(child)
        end
      end

      def treat(node)
        ReverseMarkdown::Converters.lookup(node.name).convert(node)
      end

      def escape_keychars(string)
        string.gsub(/[\*\_]/, '*' => '\*', '_' => '\_')
      end

      def extract_title(node)
        title = escape_keychars(node['title'].to_s)
        title.empty? ? '' : %[ "#{title}"]
      end
    end
  end
end
