require 'spec_helper'

describe ReverseMarkdown::Mapper do
  let(:input)    { File.read('spec/assets/minimum.html') }
  let(:document) { Nokogiri::HTML(input) }
  let(:mapper)   { ReverseMarkdown::Mapper.new }

  context "error handling" do

    let(:unknown_element) { Nokogiri::XML::Node.new('foo', document) }

    it "raises error if told so" do
      mapper.raise_errors = true
      expect {
        mapper.__send__(:opening, unknown_element)
      }.to raise_error(ReverseMarkdown::ParserError)
    end

    it "supresses errors if told so" do
      mapper.raise_errors = false
      expect {
        mapper.__send__(:opening, unknown_element)
      }.not_to raise_error
    end

    context "with Rails present" do

      module Rails # Fake Rails for specs
        def self.logger; @@logger ||= Logger.new; end
        class Logger; def info(message); end; end
      end

      it "logs with Rails.logger if present" do
        Rails.logger.should_receive(:info)
        mapper.__send__(:ending, unknown_element)
      end
    end
  end
end