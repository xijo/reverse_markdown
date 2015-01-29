module ReverseMarkdown
  class Config
    attr_accessor :unknown_tags, :github_flavored, :syntax_highlight

    def initialize
      @unknown_tags    = :pass_through
      @github_flavored = false
      @inline_options = {}
      @syntax_highlight = :plain
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

    def syntax_highlight
      @inline_options[:syntax_highlight] || @syntax_highlight
    end
  end
end
