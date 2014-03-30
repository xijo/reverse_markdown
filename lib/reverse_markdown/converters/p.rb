module ReverseMarkdown
  module Converters
    class P < Base
      def convert(node)
        "\n\n" << treat_children(node).strip << "\n\n"
      end
    end

    register :p, P.new
  end
end
