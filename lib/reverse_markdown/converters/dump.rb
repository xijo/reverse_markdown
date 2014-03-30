module ReverseMarkdown
  module Converters
    class Dump < Base
      def convert(node)
        node.to_s
      end
    end
  end
end
