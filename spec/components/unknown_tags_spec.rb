require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/unknown_tags.html') }
  let(:document) { Nokogiri::HTML(input) }
  let(:result)   { ReverseMarkdown.convert(input) }

  context 'with ignore_unknown_tags enabled' do
    before { ReverseMarkdown.config.ignore_unknown_tags = true }

    it { result.should include "<foo><bar>Foo with bar</bar></foo>" }
  end

  context 'with ignore_unknown_tags disabled' do
    before { ReverseMarkdown.config.ignore_unknown_tags = false }

    it { expect { result }.to raise_error(ReverseMarkdown::UnknownTagError) }
  end
end

