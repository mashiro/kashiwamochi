require 'spec_helper'

describe Kashiwamochi::Sort do
  before do
    @asc = Kashiwamochi::Sort::DIRS[:asc]
    @desc = Kashiwamochi::Sort::DIRS[:desc]
  end

  describe '#dir' do
    before { @sort = Kashiwamochi::Sort.new('name', nil) }
    subject { @sort }

    context 'assign "asc"' do
      before { @sort.dir = 'asc' }
      its(:dir) { should eq @asc }
    end

    context 'assign "desc"' do
      before { @sort.dir = 'desc' }
      its(:dir) { should eq @desc }
    end

    context 'assign nil' do
      before { @sort.dir = nil }
      its(:dir) { should eq @asc }
    end

    context 'assign "test"' do
      before { @sort.dir = 'test' }
      its(:dir) { should eq @asc }
    end
  end

  describe '#asc? / #desc?' do
    before { @sort = Kashiwamochi::Sort.new('name', nil) }
    subject { @sort }

    context 'when ASC' do
      before { @sort.dir = 'ASC' }
      its(:asc?) { should be_true }
      its(:desc?) { should be_false }
    end

    context 'when DESC' do
      before { @sort.dir = 'DESC' }
      its(:asc?) { should be_false }
      its(:desc?) { should be_true }
    end
  end

  describe '#toggle' do
    before { @sort = Kashiwamochi::Sort.new('name', 'asc') }

    context 'not toggled' do
      subject { @sort }
      its(:asc?) { should be_true }
      its(:desc?) { should be_false }
      its(:dir) { should eq @asc }
    end

    context 'one time' do
      subject { @sort.toggle }
      its(:asc?) { should be_false }
      its(:desc?) { should be_true }
      its(:dir) { should eq @desc }
    end

    context 'two times' do
      subject { @sort.toggle.toggle }
      its(:asc?) { should be_true }
      its(:desc?) { should be_false }
      its(:dir) { should eq @asc }
    end

    context 'three time' do
      subject { @sort.toggle.toggle.toggle }
      its(:asc?) { should be_false }
      its(:desc?) { should be_true }
      its(:dir) { should eq @desc }
    end
  end

  describe '.parse' do
    context "with 'name asc'" do
      subject { Kashiwamochi::Sort.parse('name asc') }
      its(:key) { should eq 'name' }
      its(:dir) { should eq @asc }
      it { should be_valid }
    end

    context "with '  name  asc  '" do
      subject { Kashiwamochi::Sort.parse('  name  asc  ') }
      its(:key) { should eq 'name' }
      its(:dir) { should eq @asc }
      it { should be_valid }
    end

    context "with ' aa bb cc dd '" do
      subject { Kashiwamochi::Sort.parse(' aa bb cc dd ') }
      its(:key) { should eq 'aa' }
      its(:dir) { should eq @asc }
      it { should be_valid }
    end

    context "with nil" do
      subject { Kashiwamochi::Sort.parse(nil) }
      its(:key) { should be_empty }
      its(:dir) { should eq @asc }
      it { should_not be_valid }
    end

    context "with ''" do
      subject { Kashiwamochi::Sort.parse('') }
      its(:key) { should be_empty }
      its(:dir) { should eq @asc }
      it { should_not be_valid }
    end
  end
end
