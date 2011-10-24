require 'spec_helper'

describe Kashiwamochi::Query do
  describe '#initialize' do
    context 'with {:foo => 1, :bar => 2, :to_s => 3, :s => ["name asc", "  ", "created_at desc"]}' do
      before { @q = Kashiwamochi::Query.new(:foo => 1, :bar => 2, :to_s => 3, :s => ["name asc", "  ", "created_at desc"]) }
      subject { @q }

      describe 'length' do
        context 'search_params' do
          subject { @q.search_params }
          its(:length) { should eq 3 }
        end

        context 'sort_params' do
          subject { @q.sort_params }
          its(:length) { should eq 2 }
        end
      end

      context 'having' do
        its(:foo) { should eq 1 }
        its(:bar) { should eq 2 }
        its(:to_s) { should eq 3 }
      end

      context 'missing' do
        its(:buzz) { should be_nil }
      end

      context 'alias' do
        its(:attribute_foo) { should eq 1 }
        its(:original_to_s) { should be_an_instance_of String }
      end

    end
  end

  describe '#sorts_query' do
    context 'build with {:s => ["name asc", "  ", "created_at desc"]}' do
      before { @q = Kashiwamochi::Query.new(:s => ["name asc", "  ", "created_at desc"]) }
      subject { @q.sorts_query(keys) }

      context 'with empty' do
        let(:keys) { [] }
        it { should eq 'name asc, created_at desc' }
      end

      context 'with :name' do
        let(:keys) { [:name] }
        it { should eq 'name asc' }
      end

      context 'with :created_at' do
        let(:keys) { [:created_at] }
        it { should eq 'created_at desc' }
      end

      context 'with [:name, :created_at]' do
        let(:keys) { [:name, :created_at] }
        it { should eq 'name asc, created_at desc' }
      end

      context 'with [:foo, :bar]' do
        let(:keys) { [:foo, :bar] }
        it { should be_nil }
      end
    end
  end

  describe '#to_option' do
    before { @q = Kashiwamochi::Query.new(:name => 'aira', :s => ["created_at desc"]) }
    subject { @q.to_option }
    it { should be_an_instance_of Hash }
    it { should eq ({:name => 'aira', :s => ['created_at desc']}) }
  end
end
