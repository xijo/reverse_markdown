require 'simplecov'
require 'debug' unless RUBY_ENGINE == 'jruby'

SimpleCov.profiles.define 'gem' do
  skip '/spec/'
  skip '/autotest/'
  group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'reverse_markdown'

RSpec.configure do |config|
  config.after(:each) do
    ReverseMarkdown.instance_variable_set(:@config, nil)
  end

  config.around(jruby: :exclude) do |example|
    if RUBY_ENGINE == 'jruby'
      example.metadata[:skip] = true
    else
      example.call
    end
  end
end

def node_for(html)
  Nokogiri::HTML.parse(html).root.children.last.child
end
