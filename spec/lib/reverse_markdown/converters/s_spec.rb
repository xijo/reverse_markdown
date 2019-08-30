require 'spec_helper'

describe ReverseMarkdown::Converters::S do
  let(:converter) { ReverseMarkdown::Converters::S.new }

  it 'returns an empty string if the node is empty' do
    input = node_for('<s></s>')
    expect(converter.convert(input)).to eq ''
  end

  it 'returns just the content if the s tag is nested in another strong' do
    input = node_for('<s><s>foo</s></s>')
    expect(converter.convert(input.children.first)).to eq '~foo~'
  end

  it 'moves border whitespaces outside of the delimiters tag' do
    input = node_for("<s> \n foo </s>")
    expect(converter.convert(input)).to eq " ~foo~ "
  end
end
