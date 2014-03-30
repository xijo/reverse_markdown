module ReverseMarkdown
  module Converters
    class Br < Base
      def convert(node)
        "  \n"
      end
    end

    register :br, Br.new
  end
end
