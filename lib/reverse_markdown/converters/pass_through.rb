module ReverseMarkdown
  module Converters
    class PassThrough < Base
      def convert(node)
        treat_children(node)
      end
    end

    register :document, PassThrough.new
    register :html,     PassThrough.new
    register :body,     PassThrough.new
    register :span,     PassThrough.new
  end
end
