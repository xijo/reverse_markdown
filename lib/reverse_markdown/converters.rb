module ReverseMarkdown
  module Converters
    def self.register(tag_name, converter)
      @@converters ||= {}
      @@converters[tag_name.to_sym] = converter
    end

    def self.lookup(tag_name)
      @@converters[tag_name.to_sym] or raise "unknown tag: #{tag_name}"
    end
  end
end
