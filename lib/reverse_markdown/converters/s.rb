module ReverseMarkdown
  module Converters
    class S < Base
      def convert(node, state = {})
        content = treat_children(node, state)
        if content.strip.empty?
          content
        else
          "#{content[/^\s*/]}~#{content.strip}~#{content[/\s*$/]}"
        end
      end
    end

    register :s, S.new
  end
end
