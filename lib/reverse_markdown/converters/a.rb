module ReverseMarkdown
  module Converters
    class A < Base
      def convert(node)
        name  = treat_children(node)
        href  = node['href']
        title = extract_title(node)

        if href.to_s.start_with?('#') || href.to_s.empty? || name.empty?
          name
        else
          link = "[#{name}](#{href}#{title})"
          link.prepend(' ') if node.previous_sibling.to_s.end_with?('!')
          link
        end
      end
    end

    register :a, A.new
  end
end
