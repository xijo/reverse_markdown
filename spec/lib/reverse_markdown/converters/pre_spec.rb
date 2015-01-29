require 'spec_helper'
describe ReverseMarkdown::Converters::Pre do
  let(:converter) { ReverseMarkdown::Converters::Pre.new }
  context 'for standard markdown' do
    before { ReverseMarkdown.config.github_flavored = false }
    it 'converts with indentation' do
      node = node_for("<pre>puts foo</pre>")
      expect(converter.convert(node)).to include " puts foo\n"
    end
  end
  context 'for github_flavored markdown plain' do
    before { ReverseMarkdown.config.github_flavored = true }
    it 'converts with backticks' do
      node = node_for("<pre>puts foo</pre>")
      expect(converter.convert(node)).to include "```\nputs foo\n```"
    end
    it 'includes the given highlight language' do
      node = node_for("<div class='highlight highlight-ruby'><pre>puts foo</pre></div>")
      expect(converter.convert(node.children.first)).to include "```\nputs foo\n```"
    end
    it 'includes the given highlight language confluence way' do
      node = node_for("<pre class=\"theme: Confluence; brush: php; gutter: false\">echo 'foo'</pre>")
      expect(converter.convert(node)).to include "```\necho 'foo'\n```"
    end
  end
  context 'for github_flavored markdown dobell' do
    before { ReverseMarkdown.config.github_flavored = true, ReverseMarkdown.config.syntax_highlight = 'dobell' }
    it 'converts with backticks' do
      node = node_for("<pre>puts foo</pre>")
      expect(converter.convert(node)).to include "```\nputs foo\n```"
    end
    it 'includes the given highlight language dobell waty' do
      node = node_for("<div class='highlight highlight-ruby'><pre>puts foo</pre></div>")
      expect(converter.convert(node.children.first)).to include "```ruby\n"
    end
    it 'includes the given highlight language confluence way' do
      node = node_for("<pre class=\"theme: Confluence; brush: php; gutter: false\">echo 'foo'</pre>")
      expect(converter.convert(node)).to include "```\necho 'foo'\n```"
    end
  end
  context 'for github_flavored markdown confluence' do
    before { ReverseMarkdown.config.github_flavored = true, ReverseMarkdown.config.syntax_highlight = 'confluence' }
    it 'converts with backticks' do
      node = node_for("<pre>puts foo</pre>")
      expect(converter.convert(node)).to include "```\nputs foo\n```"
    end
    it 'includes the given highlight language confluence way' do
      node = node_for("<pre class=\"theme: Confluence; brush: php; gutter: false\">echo 'foo'</pre>")
      expect(converter.convert(node)).to include "```php\n"
    end
    it 'includes the given highlight language dobell way' do
      node = node_for("<div class='highlight highlight-ruby'><pre>puts foo</pre></div>")
      expect(converter.convert(node.children.first)).to include "```\nputs foo\n```"
    end
  end
end