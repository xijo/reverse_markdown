require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/code.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { should match /inline `code` block/ }
  it { should match /\    var this\;\n    this\.is/ }
  it { should match /block"\)\n    console/ }

end

