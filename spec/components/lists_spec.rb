require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/lists.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should match /\n- unordered list entry\n/ }
  it { should match /\n- unordered list entry 2\n/ }
  it { should match /\n1. ordered list entry\n/ }
  it { should match /\n2. ordered list entry 2\n/ }
  it { should match /\n1. list entry 1st hierarchy\n/ }
  it { should match /\n {2}- nested unsorted list entry\n/ }
  it { should match /\n {4}1. deep nested list entry\n/ }

  context "nested list with no whitespace" do
    it { should match /\n- item a\n/ }
    it { should match /\n- item b\n/ }
    it { should match /\n {2}- item bb\n/ }
    it { should match /\n {2}- item bc\n/ }
  end

  context "nested list with lots of whitespace" do
    it { should match /\n- item wa \n/ }
    it { should match /\n- item wb \n/ }
    it { should match /\n  - item wbb \n/ }
    it { should match /\n  - item wbc \n/ }
  end

  context "lists containing links" do
    it { should match /\n- \[1 Basic concepts\]\(Basic_concepts\)\n/ }
    it { should match /\n- \[2 History of the idea\]\(History_of_the_idea\)\n/ }
    it { should match /\n- \[3 Intelligence explosion\]\(Intelligence_explosion\)\n/ }
  end

  context "lists containing embedded <p> tags" do
    xit { should match /\n- I want to have a party at my house!\n/ }
  end

  context "list item containing multiple <p> tags" do
    xit { should match /\n- li 1, p 1\n\n- li 1, p 2\n/ }
  end

  context 'it produces correct numbering' do
    it { should include "1. one" }
    it { should include "  1. one one" }
    it { should include "  2. one two" }
    it { should include "2. two" }
    it { should include "  1. two one" }
    it { should include "    1. two one one" }
    it { should include "    2. two one two" }
    it { should include "  2. two two" }
    it { should include "3. three" }
  end
end
