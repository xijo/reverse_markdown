require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/quotation.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should match /^    Block of code$/ }
  it { should include "\n> First quoted paragraph\n> \n> Second quoted paragraph" }

end
