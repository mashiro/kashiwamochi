require 'spec_helper'

describe Kashiwamochi::ActionView do
  describe '#search_form_for' do
    before do
      @q = Kashiwamochi::Query.new(:name => 'test', :s => ['name desc'])
      helper.search_form_for @q, :url => {:controller => 'users', :action => 'index'} do |f|
        @f = f
      end
    end
    subject { @f }

    it { should be_an_instance_of ActionView::Helpers::FormBuilder }
  end

  describe '#search_sort_link_to' do
    before do
      @q = Kashiwamochi::Query.new(:name => 'test', :s => ['name desc'])
      @link = helper.search_sort_link_to(@q, :name, 'User name', :controller => 'users', :action => 'index')
    end
    subject { @link }

    it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D%5B%5D=name\+asc") }
    it { should match %r(class="name_sort_link sort_link desc") }
    it { should match %r(User name) }
  end
end
