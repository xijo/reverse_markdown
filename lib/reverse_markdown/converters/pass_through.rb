module ReverseMarkdown
  module Converters
    class PassThrough < Base
      def convert(node)
        node.to_s
      end
    end
  end
end
