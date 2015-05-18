require 'spec_helper'

describe ReverseMarkdown do

  let(:input)    { File.read('spec/assets/em.html') }
  let(:document) { Nokogiri::HTML(input) }
  subject { ReverseMarkdown.convert(input) }

  it { is_expected.to match /Hi _T_\*\*_he_re, y_ou_\*\* _htm_l user\./ }

end
