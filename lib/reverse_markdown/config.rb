module ReverseMarkdown
  class Config
    attr_accessor :raise_errors, :log_level, :log_enabled, :ignore_unknown_tags, :github_flavored

    def initialize
      reset
    end

    def apply(options = {})
      options.each do |method, value|
        __send__(:"#{method}=", value)
      end
    end

    def reset
      @raise_errors        = false
      @log_level           = :info
      @log_enabled         = true
      @ignore_unknown_tags = true
      @github_flavored     = false
    end
  end
end
