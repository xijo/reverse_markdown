module ReverseMarkdown
  module Converters
    class Iframe < Base
      def convert(node, state = {})
        content = treat_children(node, state)
        doc = Nokogiri::HTML(content)
        doc.css('iframe').map { |i| i['src'] }.join('\n')
      end
    end

    register :iframe, Iframe.new
  end
end
