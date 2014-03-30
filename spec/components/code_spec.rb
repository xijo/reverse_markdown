require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/code.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should match /inline `code` block/ }
  it { should match /\    var this\;\n    this\.is/ }
  it { should match /block"\)\n    console/ }

  context "with github style code blocks" do
    subject { ReverseMarkdown.convert(input, github_flavored: true) }
    it { should match /inline `code` block/ }
    it { should match /```\nvar this\;\nthis/ }
    it { should match /it is"\) ?\n```/ }
  end

  context "code with indentation" do
    subject { ReverseMarkdown.convert(input) }
    it { should match(/^    tell application "Foo"\n/) }
    it { should match(/^        beep\n/) }
    it { should match(/^    end tell\n/) }
  end

end

