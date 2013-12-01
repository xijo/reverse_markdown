require 'spec_helper'

describe ReverseMarkdown::Mapper do
  let(:input)    { File.read('spec/assets/minimum.html') }
  let(:document) { Nokogiri::HTML(input) }
  let(:mapper)   { ReverseMarkdown::Mapper.new }

  it "behaves in a sane way when root element is nil" do
    mapper.process_root(nil).should == ''
  end

  describe "logging options" do
    it "has a default log level info" do
      mapper.log_level.should eq :info
    end

    it "overwrites log level if option is given" do
      mapper = ReverseMarkdown::Mapper.new(log_level: :error)
      mapper.log_level.should eq :error
    end

    it "enables logging by default" do
      mapper.log_enabled.should be_true
    end

    it "disables logging if told to" do
      mapper = ReverseMarkdown::Mapper.new(log_enabled: false)
      mapper.log_enabled.should be_false
    end
  end

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
