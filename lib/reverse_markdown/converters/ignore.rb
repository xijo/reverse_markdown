module ReverseMarkdown
  module Converters
    class Ignore < Base
      def convert(node)
        '' # noop
      end
    end

    register :colgroup, Ignore.new
    register :col,      Ignore.new
  end
end
