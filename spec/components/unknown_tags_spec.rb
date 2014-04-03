require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/unknown_tags.html') }
  let(:document) { Nokogiri::HTML(input) }
  let(:result)   { ReverseMarkdown.convert(input) }

  context 'with unknown_tags = :pass_through' do
    before { ReverseMarkdown.config.unknown_tags = :pass_through }

    it { result.should include "<foo><bar>Foo with bar</bar></foo>" }
  end

  context 'with unknown_tags = :raise' do
    before { ReverseMarkdown.config.unknown_tags = :raise }

    it { expect { result }.to raise_error(ReverseMarkdown::UnknownTagError) }
  end

  context 'with unknown_tags = :drop' do
    before { ReverseMarkdown.config.unknown_tags = :drop }

    it { result.should eq '' }
  end

  context 'with unknown_tags = :bypass' do
    before { ReverseMarkdown.config.unknown_tags = :bypass }

    it { result.should eq "Foo with bar\n\n" }
  end

  context 'with unknown_tags = :something_wrong' do
    before { ReverseMarkdown.config.unknown_tags = :something_wrong }

    it { expect { result }.to raise_error(ReverseMarkdown::InvalidConfigurationError) }
  end
end

