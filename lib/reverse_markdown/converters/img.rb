module ReverseMarkdown
  module Converters
    class Img < Base
      def convert(node)
        alt   = node['alt']
        src   = node['src']
        title = extract_title(node)
        " ![#{alt}](#{src}#{title})"
      end
    end

    register :img, Img.new
  end
end
