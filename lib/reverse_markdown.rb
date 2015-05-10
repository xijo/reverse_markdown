require 'digest'
require 'nokogiri'

require 'reverse_markdown/version'
require 'reverse_markdown/errors'
require 'reverse_markdown/cleaner'
require 'reverse_markdown/config'
require 'reverse_markdown/converters'
require 'reverse_markdown/converters/base'

Dir[File.dirname(__FILE__) + '/reverse_markdown/converters/*.rb'].each do |file|
  require file
end

module ReverseMarkdown

  def self.convert(input, options = {})
    root = case input
      when String                  then Nokogiri::HTML(input).root
      when Nokogiri::XML::Document then input.root
      when Nokogiri::XML::Node     then input
    end

    root or return ''

    result = config.with(options) do
      ReverseMarkdown::Converters.lookup(root.name).convert(root)
    end
    cleaner.tidy(result)
  end

  def self.config
    @config ||= Config.new
    yield @config if block_given?
    @config
  end

  def self.cleaner
    @cleaner ||= Cleaner.new
  end

end
