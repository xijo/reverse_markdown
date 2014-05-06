require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/paragraphs.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should_not start_with "\n\n" }
  it { should start_with "First content\n\nSecond content\n\n" }
  it { should include "\n\n*Complex*\n\n    Content" }
end
