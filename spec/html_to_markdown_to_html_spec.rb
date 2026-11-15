# coding:utf-8

require 'kramdown'
require 'spec_helper'

describe 'Round trip: HTML to markdown (via reverse_markdown) to HTML (via redcarpet)' do

  # helpers

  def roundtrip_should_preserve(input)
    output = html2markdown2html input
    expect(normalize_html(output)).to eq normalize_html(input)
  end

  def html2markdown2html(orig_html)
    markdown = ReverseMarkdown.convert orig_html
    new_html = Kramdown::Document.new(markdown).to_html
    new_html
  end

  def normalize_html(html)
    squeeze_whitespace(html).gsub('> <', '><').strip
  end

  def squeeze_whitespace(string)
    string.tr("\n\t", ' ').squeeze(' ').gsub(/\A \z/, '')
  end

  # specs

  it "should preserve <blockquote> blocks" do
    roundtrip_should_preserve('<blockquote><p>some text</p></blockquote>')
  end

  it "should preserve unordered lists" do
    roundtrip_should_preserve("
      <ol>
        <li>Bird</li>
        <li>McHale</li>
        <li>Parish</li>
      </ol>
    ")
  end

  it "should preserve ordered lists" do
    roundtrip_should_preserve("
      <ul>
        <li>Bird</li>
        <li>McHale</li>
        <li>Parish</li>
      </ul>
    ")
  end

  it "should preserve lists with paragraphs" do
    roundtrip_should_preserve("
      <ul>
        <li><p>Bird</p></li>
        <li><p>McHale</p></li>
        <li><p>Parish</p></li>
      </ul>
      ")
  end

  it "should preserve paragraphs before and after nested lists" do
    roundtrip_should_preserve(
      '<ul><li><p>Source:</p><ul><li><p>Readable path.</p></li>' \
        '<li><p>Readable IO.</p></li></ul><p>More details.</p></li>' \
        '<li><p>Destination:</p><ul><li><p>Writable path.</p></li>' \
        '<li><p>Writable IO.</p></li></ul></li></ul>'
    )
  end

  it "should preserve mixed nested lists and their numbering" do
    roundtrip_should_preserve(
      '<ol><li><p>First:</p><ul><li><p>Child:</p><ol>' \
        '<li><p>Grandchild one.</p></li><li><p>Grandchild two.</p></li></ol></li></ul></li>' \
        '<li><p>Second.</p></li></ol>'
    )
  end

  %w[ul ol].each do |tag|
    it "should keep child lists nested below empty #{tag} items" do
      input = "<#{tag}><li><p></p><ul><li>Child.</li></ul></li></#{tag}>"
      output = html2markdown2html(input)
      expected = "<#{tag}><li><ul><li>Child.</li></ul></li></#{tag}>"

      expect(normalize_html(output)).to eq expected
    end
  end

  it "should preserve <hr> tags" do
    roundtrip_should_preserve("<hr />")
  end

  it "should preserve <em> tags" do
    roundtrip_should_preserve("<p><em>yes!</em></p>")
  end

  it "should preserve links inside <strong> tags" do
    roundtrip_should_preserve(%{<p><strong><a href="/wiki/Western_philosophy" title="Western philosophy">Western philosophy</a></strong></p>})
  end

  it "should preserve <strong> tags" do
    roundtrip_should_preserve("<p><strong>yes!</strong></p>")
  end

  it "should preserve <br> tags" do
    roundtrip_should_preserve("<p>yes!<br />\n we can!</p>")
  end

  it "should preserve <a> tags" do
    roundtrip_should_preserve(%{<p>This is <a href="http://example.com/" title="Title">an example</a> inline link.</p>})
    roundtrip_should_preserve(%{<p><a href="http://example.net/">This link</a> has no title attribute.</p>})
  end

  it "should preserve <img> tags" do
    roundtrip_should_preserve(%{<p><img src="http://foo.bar/dog.png" alt="My Dog" title="Ralph" /></p>})
    roundtrip_should_preserve(%{<p><img src="http://foo.bar/dog.png" alt="My Dog" /></p>})
  end

  it "should preserve code blocks" do
    roundtrip_should_preserve(%{
      <p>This is a normal paragraph:</p>

      <pre><code>This is a code block. </code></pre>
    })
  end

  it "should preserve code blocks with embedded whitespace" do
    roundtrip_should_preserve(%{
      <p>Here is an example of AppleScript:</p>

      <pre><code>tell application Foo
          beep
      end tell
      </code></pre>
    })
  end
end
