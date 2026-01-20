require 'spec_helper'

describe ReverseMarkdown::Converters::Em do
  let(:converter) { ReverseMarkdown::Converters::Em.new }

  it 'returns an empty string if the node is empty' do
    input = node_for('<em></em>')
    expect(converter.convert(input)).to eq ''
  end

  it 'returns just the content if the em tag is nested in another em' do
    input = node_for('<em><em>foo</em></em>')
    expect(converter.convert(input.children.first, already_italic: true)).to eq 'foo'
  end

  it 'moves border whitespaces outside of the delimiters tag' do
    input = node_for("<em> \n foo </em>")
    expect(converter.convert(input)).to eq " _foo_ "
  end

  it 'splits markers at paragraph breaks' do
    # Issue #95: <br><br> inside em creates a paragraph break
    # Markers must be split so markdown renders correctly
    result = ReverseMarkdown.convert('<em>hello<br><br>world</em>')
    expect(result).to include('_hello_')
    expect(result).to include('_world_')
  end

  it 'merges adjacent em tags into single emphasis' do
    # Issue #99: Adjacent emphasis tags like <em>wo</em><em>rd</em>
    # should produce _word_ not _wo__rd_
    expect(ReverseMarkdown.convert('<em>wo</em><em>rd</em>')).to eq '_word_'
  end

  it 'merges multiple adjacent em tags' do
    expect(ReverseMarkdown.convert('<em>a</em><em>b</em><em>c</em>')).to eq '_abc_'
  end

  it 'keeps separate emphasis when tags have whitespace between them' do
    expect(ReverseMarkdown.convert('<em>a</em> <em>b</em>')).to eq '_a_ _b_'
  end
end
