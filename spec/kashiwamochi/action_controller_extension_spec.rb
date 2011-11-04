require 'spec_helper'
require 'action_controller/railtie'

include Kashiwamochi::ActionControllerExtension

describe Kashiwamochi::ActionControllerExtension do
  describe '#build_search_query' do
    before do
      instance_eval <<-EOS
        def params
          @params
        end
      EOS
    end
    subject do
      build_search_query!
      @q
    end

    context 'with query' do
      before do
        @params = {:q => {:name => 'foo'}}
      end

      it { should be_an_instance_of Kashiwamochi::Query }
      its(:name) { should eq 'foo' }
    end

    context 'without query' do
      before do
        @params = {}
      end

      it { should be_an_instance_of Kashiwamochi::Query }
      its(:name) { should be_nil }
    end
  end
end
