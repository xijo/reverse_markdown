require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/paragraphs.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { subject.should_not start_with "\n\n" }
  it { subject.should start_with "First content\n\nSecond content\n\n" }
  it { subject.should include "\n\n*Complex*\n\n    Content" }
end
