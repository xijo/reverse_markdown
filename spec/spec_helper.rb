require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
# require 'byebug'

SimpleCov.adapters.define 'gem' do
  add_filter '/spec/'
  add_filter '/autotest/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'reverse_markdown'

RSpec.configure do |config|
  config.after(:each) do
    ReverseMarkdown.config.reset
  end
end
