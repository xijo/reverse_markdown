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
          " [#{name}](#{href}#{title})"
        end
      end
    end

    register :a, A.new
  end
end
