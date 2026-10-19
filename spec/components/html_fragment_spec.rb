require 'spec_helper'

describe ReverseMarkdown do
  let(:input)    { File.read('spec/assets/html_fragment.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { is_expected.to eq("naked text 1\n\nparagraph text\n\nnaked text 2") }

  it 'converts a Nokogiri document fragment through its child converters' do
    fragment = Nokogiri::HTML.fragment('<h1>Title</h1><p>Some <strong>text</strong>.</p>')
    original = fragment.to_html

    expect(ReverseMarkdown.convert(fragment)).to eq ReverseMarkdown.convert(original)
    expect(fragment.to_html).to eq original
  end
end
