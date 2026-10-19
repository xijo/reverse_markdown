module ReverseMarkdown
  # Conversion-local storage for code that must bypass prose cleanup. Capture
  # each line separately so container converters can still indent and quote it.
  class LiteralContent
    # NUL is not valid HTML text. Letter guards keep internal markers
    # intact when surrounding converters strip whitespace from their output.
    MARKER = /RMC\0(\d+)\0END/

    def initialize
      @values = []
    end

    def protect(content)
      content.lines("\n").map do |line|
        marker = "RMC\0#{@values.length}\0END"
        @values << line.delete_suffix("\n")
        line.end_with?("\n") ? "#{marker}\n" : marker
      end.join
    end

    def restore(markdown)
      return markdown if @values.empty?

      markdown.gsub(MARKER) { @values.fetch(Regexp.last_match(1).to_i) }
    end
  end

  private_constant :LiteralContent
end
