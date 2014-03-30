require 'spec_helper'

describe ReverseMarkdown::Cleaner do
  let(:cleaner) { ReverseMarkdown::Cleaner.new }

  describe '#remove_newlines' do
    it 'removes more than 2 subsequent newlines' do
      result = cleaner.remove_newlines("foo\n\n\nbar")
      result.should eq "foo\n\nbar"
    end

    it 'skips single and double newlines' do
      result = cleaner.remove_newlines("foo\nbar\n\nbaz")
      result.should eq "foo\nbar\n\nbaz"
    end
  end

  describe '#remove_inner_whitespaces' do
    it 'removes duplicate whitespaces from the string' do
      result = cleaner.remove_inner_whitespaces('foo  bar')
      result.should eq "foo bar"
    end

    it 'performs changes for multiple lines' do
      result = cleaner.remove_inner_whitespaces("foo  bar\nbar  foo")
      result.should eq "foo bar\nbar foo"
    end

    it 'keeps leading whitespaces' do
      result = cleaner.remove_inner_whitespaces("    foo  bar\n    bar  foo")
      result.should eq "    foo bar\n    bar foo"
    end

    it 'keeps trailing whitespaces' do
      result = cleaner.remove_inner_whitespaces("foo  \n")
      result.should eq "foo  \n"
    end

    it 'keeps trailing newlines' do
      result = cleaner.remove_inner_whitespaces("foo\n")
      result.should eq "foo\n"
    end

    it 'removes tabs as well' do
      result = cleaner.remove_inner_whitespaces("foo\t \tbar")
      result.should eq "foo bar"
    end
  end

  describe '#clean_tag_borders' do
    it 'removes not needed whitespaces from strong tags' do
      input = "foo ** foobar ** bar"
      result = cleaner.clean_tag_borders(input)
      result.should eq "foo **foobar** bar"
    end

    it 'remotes leading or trailing whitespaces independently' do
      input = "1 **fat ** 2 ** fat** 3"
      result = cleaner.clean_tag_borders(input)
      result.should eq "1 **fat** 2 **fat** 3"
    end

    it 'adds whitespaces if there are none' do
      input = "1**fat**2"
      result = cleaner.clean_tag_borders(input)
      result.should eq "1 **fat** 2"
    end

    it 'cleans italic stuff as well' do
      input = "1 __italic __ 2 __ italic__ 3__italic __4"
      result = cleaner.clean_tag_borders(input)
      result.should eq "1 __italic__ 2 __italic__ 3 __italic__ 4"
    end
  end

end
