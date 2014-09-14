require 'spec_helper'

describe ReverseMarkdown::Converters::Text do

  let(:converter) { ReverseMarkdown::Converters::Text.new }

  it 'treats newline within text as a single whitespace' do
    input = Nokogiri::XML.parse("<p>foo\nbar</p>").root
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

  it 'removes leading newlines' do
    input = Nokogiri::XML.parse("<p>\n\nfoo bar</p>").root
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

  it 'removes trailing newlines' do
    input = Nokogiri::XML.parse("<p>foo bar\n\n</p>").root
    result = converter.convert(input)
    expect(result).to eq 'foo bar'
  end

end
