require 'spec_helper'

describe ReverseMarkdown do
  let(:input)    { File.read('spec/assets/minimum.html') }
  let(:document) { Nokogiri::HTML(input) }

  it "parses string input" do
    expect(ReverseMarkdown.convert('<p>content</p>')).to eq "content\n\n"
  end

  it "preserves string-like input coercion" do
    string_like = Object.new
    string_like.define_singleton_method(:to_s) { '<p>content</p>' }

    expect(ReverseMarkdown.convert(string_like)).to eq ReverseMarkdown.convert(string_like.to_s)
  end

  it "converts nokogiri documents and elements like their serialized HTML" do
    node = document.at_css('body')

    expect(ReverseMarkdown.convert(document)).to eq ReverseMarkdown.convert(document.to_html)
    expect(ReverseMarkdown.convert(node)).to eq ReverseMarkdown.convert(node.to_html)
  end

  it "converts all document-fragment children and empty fragments" do
    fragment = Nokogiri::HTML.fragment('<h2>Title</h2><p>First</p><p>Second</p>')

    expect(ReverseMarkdown.convert(fragment)).to eq "## Title\n\nFirst\n\nSecond\n\n"
    expect(ReverseMarkdown.convert(fragment)).to eq ReverseMarkdown.convert(fragment.to_html)
    expect(ReverseMarkdown.convert(Nokogiri::HTML.fragment(''), unknown_tags: :raise)).to eq ''
  end

  it "does not serialize or force-encode direct nokogiri inputs" do
    inputs = [
      Nokogiri::HTML('<p>content</p>'),
      Nokogiri::HTML.fragment('<p>content</p>').children.first,
      Nokogiri::HTML.fragment('<p>content</p>')
    ]

    inputs.each do |node|
      node.define_singleton_method(:to_s) { raise 'serialized' }
      expect(ReverseMarkdown.convert(node, force_encoding: true)).to eq "content\n\n"
    end
  end

  it "does not fail for other nokogiri node types" do
    document = Nokogiri::XML::Document.new
    attribute = Nokogiri::XML::Attr.new(document, 'title')
    attribute.value = 'value'
    nodes = [
      Nokogiri::XML::Text.new('text', document),
      Nokogiri::XML::Comment.new(document, 'comment'),
      Nokogiri::XML::CDATA.new(document, 'data'),
      Nokogiri::XML::ProcessingInstruction.new(document, 'target', 'value'),
      attribute
    ]

    nodes.each { |node| expect { ReverseMarkdown.convert(node) }.not_to raise_error }
  end

  it "behaves in a sane way when root element is nil" do
    expect(ReverseMarkdown.convert(nil)).to eq ''
  end

  describe '#config' do
    it 'stores a given configuration option' do
      ReverseMarkdown.config.github_flavored = true
      expect(ReverseMarkdown.config.github_flavored).to eq true
    end

    it 'can be used as a block configurator as well' do
      ReverseMarkdown.config do |config|
        expect(config.github_flavored).to eq false
        config.github_flavored = true
      end
      expect(ReverseMarkdown.config.github_flavored).to eq true
    end

    describe 'force_encoding option', jruby: :exclude do
      it 'raises invalid byte sequence in UTF-8 exception' do
        # Older versions of ruby used to raise ArgumentError here. Remove when we drop support for 3.1.
        expect { ReverseMarkdown.convert("hi \255") }.to raise_error { [Encoding::CompatibilityError, ArgumentError].include?(_1.class) }
      end

      it 'handles invalid byte sequence if option is set' do
        expect(ReverseMarkdown.convert("hi \255", force_encoding: true)).to eq "hi\n\n"
      end

      it 'handles invalid bytes from string-like input if option is set' do
        string_like = Object.new
        string_like.define_singleton_method(:to_s) { "hi \255" }

        expect(ReverseMarkdown.convert(string_like, force_encoding: true)).to eq "hi\n\n"
      end
    end
  end
end
