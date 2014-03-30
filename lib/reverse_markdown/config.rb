module ReverseMarkdown
  class Config
    attr_accessor :ignore_unknown_tags, :github_flavored

    def initialize
      reset
    end

    def apply(options = {})
      options.each do |method, value|
        __send__(:"#{method}=", value)
      end
    end

    def reset
      @ignore_unknown_tags = true
      @github_flavored     = false
    end
  end
end
