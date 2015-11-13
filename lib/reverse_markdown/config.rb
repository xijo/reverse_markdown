module ReverseMarkdown
  class Config
    attr_accessor :unknown_tags, :github_flavored, :default_borders

    def initialize
      @unknown_tags     = :pass_through
      @github_flavored  = false
      @em_delimiter     = '_'.freeze
      @strong_delimiter = '**'.freeze
      @inline_options   = {}
      @default_borders  = ' '.freeze
    end

    def with(options = {})
      @inline_options = options
      result = yield
      @inline_options = {}
      result
    end

    def unknown_tags
      @inline_options[:unknown_tags] || @unknown_tags
    end

    def github_flavored
      @inline_options[:github_flavored] || @github_flavored
    end

    def default_borders
      @inline_options[:default_borders] || @default_borders
    end
  end
end
