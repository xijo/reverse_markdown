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
end
