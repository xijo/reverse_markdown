require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/basic.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { subject.should match /# h1\n/ }
  it { subject.should match /## h2\n/ }
  it { subject.should match /### h3\n/ }
  it { subject.should match /#### h4\n/ }
  it { subject.should match /\*em\*/ }
  it { subject.should match /\*\*strong\*\*/ }
  it { subject.should match /`code`/ }
  it { subject.should match /---/ }

end