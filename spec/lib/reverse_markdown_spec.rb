require 'spec_helper'

describe ReverseMarkdown do
  let(:input)    { File.read('spec/assets/minimum.html') }
  let(:document) { Nokogiri::HTML(input) }

  it "parses nokogiri documents" do
    lambda { ReverseMarkdown.convert(document) }.should_not raise_error
  end

  it "parses nokogiri elements" do
    lambda { ReverseMarkdown.convert(document.root) }.should_not raise_error
  end

  it "parses string input" do
    lambda { ReverseMarkdown.convert(input) }.should_not raise_error
  end

  it "behaves in a sane way when root element is nil" do
    ReverseMarkdown.convert(nil).should == ''
  end

  describe '#config' do
    it 'stores a given configuration option' do
      ReverseMarkdown.config.github_flavored = true
      ReverseMarkdown.config.github_flavored.should be_true
    end

    it 'can be used as a block configurator as well' do
      ReverseMarkdown.config do |config|
        config.github_flavored.should be_false
        config.github_flavored = true
      end
      ReverseMarkdown.config.github_flavored.should be_true
    end
  end
end
