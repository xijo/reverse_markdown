require 'spec_helper'

describe ReverseMarkdown::Converters::Blockquote do

  let(:converter) { ReverseMarkdown::Converters::Blockquote.new }

  it 'converts nested elements as well' do
    input = node_for("<blockquote><ul><li>foo</li></ul></blockquote>")
    result = converter.convert(input)
    expect(result).to eq "> - foo"
  end

  it 'can deal with paragraphs inside' do
    input = node_for("<blockquote><p>Some text.</p><p>Some more text.</p></blockquote>")
    result = converter.convert(input)
    expect(result).to eq "> Some text.\n> \n> Some more text."
  end

  it 'adds a newline after the quote to end it' do
    input = node_for("<blockquote>  This is a quote </blockquote>\n<img alt=\"alt\" src=\"https://path/to/file.jpg\" />")
    result = converter.convert(input)
    expect(result).to eq "> This is a quote\n\n ![alt](https://path/to/file.jpg)"
  end
end
