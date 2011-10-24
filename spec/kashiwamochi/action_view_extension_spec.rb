require 'spec_helper'
require 'action_controller/railtie'
require 'action_view/railtie'

include Kashiwamochi::ActionViewExtension
include ActionView::Helpers::UrlHelper

describe Kashiwamochi::ActionViewExtension do
  describe '#search_form_for' do
  end
  
  describe '#search_link_to' do
    before do
      @q = Kashiwamochi::Query.new(:name => 'test', :s => ['name desc'])
      @link = search_sort_link_to(@q, :name)
    end
    subject { @q }
    it { should be_an_instance_of String }
  end
end
