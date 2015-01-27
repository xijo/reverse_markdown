module ReverseMarkdown
  module Highlighters
    def self.register(type, highlighter)
      @@highlihters ||= {}
      @@highlihters[type.to_sym] = highlighter
    end

    def self.lookup(type)
      @@highlihters[type.to_sym] or ReverseMarkdown::Highlighters::Plain.new
    end
  end
end
