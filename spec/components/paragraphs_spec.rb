require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/paragraphs.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { subject.should match /First content\n\nSecond content\n\n/ }
  it { subject.should include "\n\n*Complex*\n    Content" }
end