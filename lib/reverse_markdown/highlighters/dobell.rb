module ReverseMarkdown
  module Highlighters
    class Dobell < Base
      def highlight(node)
        highlight_match = node.parent['class'].nil? ? nil : node.parent['class'].match(/highlight highlight-([a-zA-Z0-9]+)/)
        highlight_match ? highlight_match[1] : ''
      end
    end

    register :dobell, Dobell.new
  end
end