require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/tables.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { should match /\n\| header 1 \| header 2 \| header 3 \|\n\| --- \| --- \| --- \|\n/ }
  it { should match /\n\| data 1-1 \| data 2-1 \| data 3-1 \|\n/ }
  it { should match /\n\| data 1-2 \| data 2-2 \| data 3-2 \|\n/ }

  it { should match /\n\| _header oblique_ \| \*\*header bold\*\* \| `header code` \|\n| --- \| --- \| --- \|\n/ }
  it { should match /\n\| _data oblique_ \| \*\*data bold\*\* \| `data code` \|\n/ }

end
