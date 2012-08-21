require 'spec_helper'

describe Kashiwamochi::ActionView do
  describe '#search_form_for' do
    def with_concat_form_for(*args, &block)
      concat helper.search_form_for(*args, &(block || proc {}))
    end

    before do
      @q = Kashiwamochi::Query.new(:name => 'test', :s => 'name desc')
    end

    describe 'instance of' do
      before do
        helper.search_form_for @q, :url => {:controller => 'users', :action => 'index'} do |f|
          @f = f
        end
      end
      subject { @f }
      it { should be_an_instance_of ActionView::Helpers::FormBuilder }
    end

    describe 'default id and class' do
      before { @buffer = with_concat_form_for(@q, :url => '/') }
      subject { @buffer }
      it { should match %r(id="q_search") }
      it { should match %r(class="search") }
    end

    describe 'user id and class' do
      before { @buffer = with_concat_form_for(@q, :url => '/', :html => {:id => 'aaa', :class => 'bbb'}) }
      subject { @buffer }
      it { should match %r(id="aaa") }
      it { should match %r(class="search bbb") }
    end
  end

  describe '#search_sort_link_to' do
    context 'with sort' do
      before do
        @q = Kashiwamochi::Query.new(:name => 'test', :s => 'name desc')
        @link1 = helper.search_sort_link_to(@q, :name, 'User name', :controller => 'users', :action => 'index')
        @link2 = helper.search_sort_link_to(@q, :age, 'User Age', :controller => 'users', :action => 'index')
        @link3 = helper.search_sort_link_to(@q, :sex, 'User Sex', :controller => 'users', :action => 'index', :default_order => 'desc')
      end

      describe 'name' do
        subject { @link1 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=name\+asc") }
        it { should match %r(class="name_sort_link sort_link desc") }
        it { should match %r(User name) }
      end

      describe 'age' do
        subject { @link2 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=age\+asc") }
        it { should match %r(class="age_sort_link sort_link") }
        it { should match %r(User Age) }
      end

      describe 'sex' do
        subject { @link3 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=sex\+desc") }
        it { should match %r(class="sex_sort_link sort_link") }
        it { should match %r(User Sex) }
      end
    end

    context 'without sort' do
      before do
        @q = Kashiwamochi::Query.new(:name => 'test')
        @link1 = helper.search_sort_link_to(@q, :name, 'User name', :controller => 'users', :action => 'index')
        @link2 = helper.search_sort_link_to(@q, :age, 'User age', :controller => 'users', :action => 'index')
        @link3 = helper.search_sort_link_to(@q, :sex, 'User sex', :controller => 'users', :action => 'index', :default_order => 'desc')
      end

      describe 'name' do
        subject { @link1 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=name\+asc") }
        it { should match %r(class="name_sort_link sort_link") }
        it { should match %r(User name) }
      end

      describe 'age' do
        subject { @link2 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=age\+asc") }
        it { should match %r(class="age_sort_link sort_link") }
        it { should match %r(User age) }
      end

      describe 'sex' do
        subject { @link3 }
        it { should match %r(href="/users\?q%5Bname%5D=test&amp;q%5Bs%5D=sex\+desc") }
        it { should match %r(class="sex_sort_link sort_link") }
        it { should match %r(User sex) }
      end
    end
  end
end
