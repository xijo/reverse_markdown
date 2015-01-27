module ReverseMarkdown
  module Highlighters
    class Plain < Base
      def highlight(node)
        return ''
      end
    end

    register :plain, Plain.new
  end
end