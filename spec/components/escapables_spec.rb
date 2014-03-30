require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/escapables.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  context "multiple asterisks" do
    it { should include ' \*\*two asterisks\*\* ' }
    it { should include ' \*\*\*three asterisks\*\*\* ' }
  end

  context "multiple underscores" do
    it { should include ' \_\_two underscores\_\_ ' }
    it { should include ' \_\_\_three underscores\_\_\_ ' }
  end

  context "underscores within words in code blocks" do
    it { should include '    var theoretical_max_infin = 1.0;' }
  end
end
