require 'simplecov'
require 'byebug'


SimpleCov.adapters.define 'gem' do
  add_filter '/spec/'
  add_filter '/autotest/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'reverse_markdown'

RSpec.configure do |config|
  config.color_enabled = true
end
