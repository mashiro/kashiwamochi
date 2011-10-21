require 'spec_helper'

describe Kashiwamochi::Configuration do
  subject { Kashiwamochi.config }

  describe '#configure' do
    before do
      Kashiwamochi.configure do |config|
        @config = config
      end
    end
    subject { @config }

    it { should be_an_instance_of Kashiwamochi::Configuration }
    it { should eq Kashiwamochi.config }
  end

  describe 'config' do
    context 'by default' do
      its(:search_key) { should eq :q }
      its(:sort_key) { should eq :s }
      its(:form_class) { should eq :search }
      its(:form_method) { should eq :form_for }
      its(:sort_link_class) { should eq :sort_link }
    end
  end
end
