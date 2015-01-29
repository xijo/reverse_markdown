module ReverseMarkdown
  module Highlighters
    class Confluence < Base
      def highlight(node)
        brush = node['class'].split(';').map.select { |e| e.strip.start_with?('brush:') }[0] unless node['class'].to_s.empty?
        brush.to_s.empty?? '' : brush.match(/:(.+)$/)[1].strip
      end
    end

    register :confluence, Confluence.new
  end
end
