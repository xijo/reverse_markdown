module ReverseMarkdown
  module Converters
    class Bypass < Base
      def convert(node)
        treat_children(node)
      end
    end

    register :document, Bypass.new
    register :html,     Bypass.new
    register :body,     Bypass.new
    register :span,     Bypass.new
    register :thead,    Bypass.new
    register :tbody,    Bypass.new
  end
end
