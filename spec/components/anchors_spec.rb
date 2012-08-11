require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/anchors.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input) }

  it { subject.should include '[Foobar](http://foobar.com)' }
  it { subject.should include '[**Strong foobar**](http://strong.foobar.com)' }
  it { subject.should include '![http://foobar.com/logo.png]' }
  it { subject.should include '![foobar image][http://foobar.com/foobar.png]' }

end