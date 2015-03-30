module ReverseMarkdown
  module Converters
    class Article < Base
      def convert(node)
        "\n" << treat_children(node) << "\n"
      end
    end

    register :article, Article.new
  end
end
