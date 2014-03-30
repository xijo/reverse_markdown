require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/anchors.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should include ' [Foobar](http://foobar.com) ' }
  it { should include ' [Fubar](http://foobar.com "f\*\*\*\*\* up beyond all recognition") ' }
  it { should include ' [**Strong foobar**](http://strong.foobar.com) ' }

  it { should include ' ![](http://foobar.com/logo.png) ' }
  it { should include ' ![foobar image](http://foobar.com/foobar.png) ' }
  it { should include ' ![foobar image 2](http://foobar.com/foobar2.png "this is the foobar image 2") ' }
  it { should include 'extra space after the [anchor](http://foobar.com).'}
  it { should include 'But inline, [there](http://foobar.com) should be a space.'}

  context "links to ignore" do
    it { should include ' ignore anchor tags with no link text ' }
    it { should include ' not ignore [![An Image](image.png)](foo.html) anchor tags with images' }
    it { should include ' pass through the text of internal jumplinks without treating them as links ' }
    it { should include ' pass through the text of anchor tags with no href without treating them as links ' }
  end

end
