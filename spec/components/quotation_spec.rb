require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/quotation.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { subject.should include "\n    Block of code" }
  it { subject.should include "\n> First quoted paragraph\n\n> Second quoted paragraph" }

end