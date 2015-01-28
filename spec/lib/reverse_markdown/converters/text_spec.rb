require 'spec_helper'

describe ReverseMarkdown::Converters::Text do

  let(:converter) { ReverseMarkdown::Converters::Text.new }

  it 'treats newline within text as a single whitespace' do
    input = node_for("<p>foo\nbar</p>")
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

  it 'removes leading newlines' do
    input = node_for("<p>\n\nfoo bar</p>")
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

  it 'removes trailing newlines' do
    input = node_for("<p>foo bar\n\n</p>")
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

  it 'keeps nbsps' do
    input = node_for("<p>foo\u00A0bar \u00A0</p>")
    result = converter.convert(input)
    expect(result).to eq "foo&nbsp;bar &nbsp;"
  end

end
