module ReverseMarkdown
  module Converters
    class Ol < Base
      def convert(node, state = {})
        +"\n" << treat_children(node, state) << "\n"
      end
    end

    register :ol, Ol.new
    register :ul, Ol.new
  end
end
