require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/from_the_wild.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it "should make sense of strong-crazy markup (as seen in the wild)" do
    subject.should ==
      '** .' + "  \n" +
      '\*\*\* intentcast ** : logo design' + "  \n" +
      '** . **'
  end

end