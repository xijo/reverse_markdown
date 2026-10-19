require 'spec_helper'
require 'kramdown'

describe ReverseMarkdown, 'literal code content' do
  def pre_html(content)
    escaped = content.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
    "<pre>#{escaped}</pre>"
  end

  it 'preserves spaces, tabs, and Markdown-looking text in inline code' do
    code = "two  spaces\tand __underscores__ **.** [ spaced ]"

    result = ReverseMarkdown.convert("<p>Copy <code>#{code}</code>.</p>")

    expect(result).to include "Copy `#{code}`."
  end

  it 'preserves empty code without leaving internal markers in the output' do
    result = ReverseMarkdown.convert('<p><code></code></p><pre></pre>', github_flavored: true)

    expect(result).to include '``'
    expect(result).to include "```\n\n```"
    expect(result).not_to include "\0"
  end

  it 'preserves literal HTML, ERB, and entity strings in code blocks' do
    code = "template = '<b><%= name %></b> &lt;tag&gt; &amp;'"

    result = ReverseMarkdown.convert(pre_html(code), github_flavored: true)

    expect(result).to include "```\n#{code}\n```"
  end

  it 'preserves inline code through list converter state changes' do
    html = '<ol><li>Copy <code>two  spaces [ spaced ]</code></li>' \
      '<li><code>second  value</code></li></ol>'

    result = ReverseMarkdown.convert(html)

    expect(result).to include '1. Copy `two  spaces [ spaced ]`'
    expect(result).to include '2. `second  value`'
  end

  [false, true].each do |github_flavored|
    context "with github_flavored: #{github_flavored}" do
      it 'preserves spaces and tabs inside code while still cleaning prose' do
        code = "puts 'two  spaces'\nvalue = 'a\tb'\nputs '__name__ **.** [ spaced ]'"
        html = "<p>before  prose</p>#{pre_html(code)}<p>after  prose</p>"

        result = ReverseMarkdown.convert(html, github_flavored: github_flavored)
        expected = github_flavored ? "```\n#{code}\n```" : code.lines.map { |line| "    #{line}" }.join

        expect(result).to include expected
        expect(result).to include 'before prose'
        expect(result).to include 'after prose'
      end

      it 'preserves repeated blank lines in code blocks' do
        code = "puts :before\n\n\n\nputs :after"

        result = ReverseMarkdown.convert(pre_html(code), github_flavored: github_flavored)
        expected = github_flavored ? "```\n#{code}\n```" : code.lines.map { |line| "    #{line}" }.join

        expect(result).to include expected
      end

      it 'preserves code in nested blockquotes through container cleanup' do
        code = "marker = '```'\nputs 'two  spaces'\n\n\nputs '__name__ [ spaced ]'"
        html = "<blockquote><blockquote>#{pre_html(code)}</blockquote></blockquote>"

        result = ReverseMarkdown.convert(html, github_flavored: github_flavored)
        expected = github_flavored ? "```\n#{code}\n```" : code.lines.map { |line| "    #{line}" }.join

        expect(result).to include expected.lines.map { |line| "> > #{line}" }.join
      end
    end
  end

  it 'preserves highlighted code as literal text, including nested line breaks' do
    html = '<pre><code><span class="name">value</span> = ' \
      '<span class="string">\'two  spaces &amp;lt;tag&amp;gt;\'</span>' \
      '<br><span class="name">puts</span> value</code></pre>'

    result = ReverseMarkdown.convert(html, github_flavored: true)

    expect(result).to include "```\nvalue = 'two  spaces &lt;tag&gt;'\nputs value\n```"
  end

  it 'does not confuse prose joined across inline elements with literal content' do
    html = '<p><span>RMC</span><span>0END</span> X0End XX0End</p>' \
      '<pre>puts :literal</pre>'

    result = ReverseMarkdown.convert(html, github_flavored: true)

    expect(result).to include 'RMC0END X0End XX0End'
    expect(result).to include "```\nputs :literal\n```"
    expect(result).not_to include "\0"
  end

  it 'does not treat invalid HTML NUL references as internal markers' do
    html = '<p>RMC&#0;0&#0;END</p><pre>puts :literal</pre>'
    prose = Nokogiri::HTML.fragment(html).at_css('p').text

    result = ReverseMarkdown.convert(html, github_flavored: true)

    expect(result).to include prose
    expect(result).to include "```\nputs :literal\n```"
    expect(result).not_to include "\0"
  end

  it 'preserves literal CDATA content from an XML document' do
    code = "value = 'a  b <tag> &amp;'"
    document = Nokogiri::XML("<pre><![CDATA[#{code}]]></pre>")

    result = ReverseMarkdown.convert(document, github_flavored: true)

    expect(result).to include "```\n#{code}\n```"
  end

  it 'preserves Unicode code without changing its encoding' do
    code = "puts 'café  世界'"

    result = ReverseMarkdown.convert(pre_html(code), github_flavored: true)

    expect(result).to include "```\n#{code}\n```"
    expect(result.encoding).to eq Encoding::UTF_8
  end

  it 'keeps indented code valid when Markdown inside blockquotes is rendered' do
    code = "puts 'two  spaces'\n\n\nputs '[ spaced ] __name__'"
    html = "<blockquote><blockquote>#{pre_html(code)}</blockquote></blockquote>"
    markdown = ReverseMarkdown.convert(html)

    rendered = Nokogiri::HTML.fragment(Kramdown::Document.new(markdown).to_html)

    expect(rendered.at_css('blockquote blockquote pre code').text).to eq "#{code}\n"
  end

  it 'restores distinct values throughout a long code block' do
    code = Array.new(180) { |index| "puts 'line #{index}  value'" }.join("\n")

    result = ReverseMarkdown.convert(pre_html(code), github_flavored: true)

    expect(result).to include "```\n#{code}\n```"
  end

  it 'preserves code without modifying a Nokogiri input node' do
    node = node_for(pre_html("puts 'two  spaces'\n\n\nputs :done"))
    original = node.to_html

    result = ReverseMarkdown.convert(node, github_flavored: true)

    expect(result).to include "```\nputs 'two  spaces'\n\n\nputs :done\n```"
    expect(node.to_html).to eq original
  end

  it 'preserves code in a native Nokogiri document fragment' do
    fragment = Nokogiri::HTML.fragment("<p>Copy this:</p>#{pre_html("puts 'two  spaces'\n\n\nputs :done")}")
    original = fragment.to_html

    result = ReverseMarkdown.convert(fragment, github_flavored: true)

    expect(result).to include "```\nputs 'two  spaces'\n\n\nputs :done\n```"
    expect(fragment.to_html).to eq original
  end

  it 'keeps literal content isolated between conversions' do
    first = ReverseMarkdown.convert(pre_html("puts 'first  value'"), github_flavored: true)
    second = ReverseMarkdown.convert(pre_html("puts 'second  value'"), github_flavored: true)

    expect(first).to include "puts 'first  value'"
    expect(second).to include "puts 'second  value'"
    expect(second).not_to include 'first'
  end
end
