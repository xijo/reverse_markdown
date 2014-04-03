require 'spec_helper'

describe ReverseMarkdown::Converters::Del do
  let(:converter) { ReverseMarkdown::Converters::Del.new }

  context 'with github_flavored = true' do
    before { ReverseMarkdown.config.github_flavored = true }

    it 'converts the input as expected' do
      input = Nokogiri::XML.parse('<del>deldeldel</del>').root
      converter.convert(input).should eq '~~deldeldel~~'
    end

    it 'skips empty tags' do
      input = Nokogiri::XML.parse('<del></del>').root
      converter.convert(input).should eq ''
    end

    it 'knows about its enabled/disabled state' do
      converter.should be_enabled
      converter.should_not be_disabled
    end
  end

  context 'with github_flavored = false' do
    before { ReverseMarkdown.config.github_flavored = false }

    it 'does not convert anything' do
      input = Nokogiri::XML.parse('<del>deldeldel</del>').root
      converter.convert(input).should eq 'deldeldel'
    end

    it 'knows about its enabled/disabled state' do
      converter.should_not be_enabled
      converter.should be_disabled
    end
  end
end
