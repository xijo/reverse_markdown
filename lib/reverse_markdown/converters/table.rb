module ReverseMarkdown
  module Converters
    class Table < Base
      def convert(node)
        "\n\n" << treat_children(node) << "\n"
      end
    end

    register :table, Table.new
  end
end
