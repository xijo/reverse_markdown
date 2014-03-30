module ReverseMarkdown
  module Converters
    def self.register(tag_name, converter)
      @@converters ||= {}
      @@converters[tag_name.to_sym] = converter
    end

    def self.lookup(tag_name)
      @@converters[tag_name.to_sym] or default_converter(tag_name)
    end

    private

    def self.default_converter(tag_name)
      if ReverseMarkdown.config.ignore_unknown_tags
        ReverseMarkdown::Converters::Dump.new
      else
        raise "unknown tag: #{tag_name}"
      end
    end
  end
end
