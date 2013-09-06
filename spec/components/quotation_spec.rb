require 'spec_helper'

describe ReverseMarkdown::Mapper do

  let(:input)    { File.read('spec/assets/quotation.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.parse_string(input, :allowed_tags => [:small]) }

  it { should include "\n    Block of code" }
  it { should include "\n> First quoted paragraph\n\n> Second quoted paragraph" }
  it { should include "\n> ## Header 2 goes here" }
  it { should include "\n> plain text" }
  it { should include "\n> - First unbulleted list item\n> - Second unbulleted list item" }
  it { should include "\n> > Double-quoted paragraph" }
  it { should include "\n> > Double-quoted plain text" }
  it { should include "\n> * * *" }
  it { should include "\n> ![with preceeding br](http://localhost/i.jpg)" }
  it { should include "\n> <small> ![with post anchor](http://localhost/i.jpg)" }
  it { should include "\n> ![without preceeding br](http://localhost/i.jpg)" }

end
