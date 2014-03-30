require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/basic.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should match /plain text ?\n/ }
  it { should match /# h1\n/ }
  it { should match /## h2\n/ }
  it { should match /### h3\n/ }
  it { should match /#### h4\n/ }
  it { should match /##### h5\n/ }
  it { should match /###### h6\n/ }

  it { should match /_em tag content_/ }
  it { should match /before and after empty em tags/ }
  it { should match /before and after em tags containing whitespace/ }
  it { should match /_double em tags_/ }
  it { should match /_double em tags in p tag_/ }

  it { should match /\*\*strong tag content\*\*/ }
  it { should match /before and after empty strong tags/ }
  it { should match /before and after strong tags containing whitespace/ }
  it { should match /\*\*double strong tags\*\*/ }
  it { should match /\*\*double strong tags in p tag\*\*/ }
  it { should match /before \*\*double strong tags containing whitespace\*\* after/ }

  it { should match /_i tag content_/ }
  it { should match /\*\*b tag content\*\*/ }

  it { should match /br tags become double space followed by newline  \n/ }
  #it { should match /br tags XXX  \n/ }

  it { should match /before hr \n\* \* \*\n after hr/ }

  it { should match /section 1\n ?\nsection 2/ }
end
