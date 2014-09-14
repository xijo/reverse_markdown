require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/from_the_wild.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it "should make sense of strong-crazy markup (as seen in the wild)" do
    expect(subject).to eq '**.' + "  \n" +
      ' \*\*\* intentcast ** : logo design' + "   \n" +
      "**.**\n\n"
  end

end
