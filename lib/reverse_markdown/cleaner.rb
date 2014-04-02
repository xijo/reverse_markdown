module ReverseMarkdown
  class Cleaner

    def tidy(string)
      clean_tag_borders(remove_leading_newlines(remove_newlines(remove_inner_whitespaces(string))))
    end

    def remove_newlines(string)
      string.gsub(/\n{3,}/, "\n\n")
    end

    def remove_leading_newlines(string)
      string.gsub /\A\n\n?/, ''
    end

    def remove_inner_whitespaces(string)
      string.each_line.inject("") do |memo, line|
        memo + preserve_border_whitespaces(line) do
          line.strip.gsub(/[ \t]{2,}/, ' ')
        end
      end
    end

    # Find non-asterisk content that is enclosed by two or
    # more asterisks. Ensure that only one whitespace occur
    # in the border area.
    # Same for underscores and brackets.
    def clean_tag_borders(string)
      result = string.gsub /\s?\*{2,}.*?\*{2,}\s?/ do |match|
        preserve_border_whitespaces(match, default_border: ' ') do
          match.strip.sub('** ', '**').sub(' **', '**')
        end
      end

      result = result.gsub /\s?\_{2,}.*?\_{2,}\s?/ do |match|
        preserve_border_whitespaces(match, default_border: ' ') do
          match.strip.sub('__ ', '__').sub(' __', '__')
        end
      end

      result.gsub /\s?\[.*?\]\s?/ do |match|
        preserve_border_whitespaces(match) do
          match.strip.sub('[ ', '[').sub(' ]', ']')
        end
      end
    end

    private

    def preserve_border_whitespaces(string, _options={}, &block)
      options = {
       default_border: ''
      }.merge(_options)
      string_start = present_or_default(string[/\A\s*/], options[:default_border])
      string_end   = present_or_default(string[/\s*\Z/], options[:default_border])
      result       = yield
      string_start + result + string_end
    end

    def present_or_default(string, default)
      if string.nil? || string.empty?
        default
      else
        string
      end
    end

  end
end
