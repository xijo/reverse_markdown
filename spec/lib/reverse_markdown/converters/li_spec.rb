require 'spec_helper'

describe ReverseMarkdown::Converters::Li do

  let(:converter) { ReverseMarkdown::Converters::Li.new }

  it 'does not fail without a valid parent context' do
    input = Nokogiri::XML.parse("<li>foo</li>").root
    result = converter.convert(input)
    expect(result).to eq "- foo\n"
  end

end
