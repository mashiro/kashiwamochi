require 'spec_helper'

describe Kashiwamochi::Sort do
  before do
    @asc = Kashiwamochi::Sort::DIRS[:asc]
    @desc = Kashiwamochi::Sort::DIRS[:desc]
  end

  describe '#parse' do
    shared_context :parse_sort do
      before do
        @sort = Kashiwamochi::Sort.parse(str)
        @is_asc = dir == @asc
        @is_valid = key != ''
      end
      subject { @sort }
      its(:key) { should eq key }
      its(:dir) { should eq dir }
      it {  @is_asc ? (should be_asc) : (should_not be_asc) }
      it { !@is_asc ? (should be_desc) : (should_not be_desc) }
      it { @is_valid ? (should be_valid) : (should_not be_valid) }
    end

    context "with 'name asc'" do
      let(:str) { 'name asc' }
      let(:key) { 'name' }
      let(:dir) { @asc }
      include_context :parse_sort
    end

    context "with '  name  asc  '" do
      let(:str) { '  name  asc  ' }
      let(:key) { 'name' }
      let(:dir) { @asc }
      include_context :parse_sort
    end

    context "with 'Name Asc'" do
      let(:str) { 'Name Asc' }
      let(:key) { 'Name' }
      let(:dir) { @asc }
      include_context :parse_sort
    end

    context "with 'name desc'" do
      let(:str) { 'name desc' }
      let(:key) { 'name' }
      let(:dir) { @desc }
      include_context :parse_sort
    end

    context "with 'name dEsC'" do
      let(:str) { 'name dEsC' }
      let(:key) { 'name' }
      let(:dir) { @desc }
      include_context :parse_sort
    end

    context "with 'name test'" do
      let(:str) { 'name test' }
      let(:key) { 'name' }
      let(:dir) { @asc }
      include_context :parse_sort
    end

    context "with 'name'" do
      let(:str) { 'name' }
      let(:key) { 'name' }
      let(:dir) { @asc }
      include_context :parse_sort
    end

    context "with ''" do
      let(:str) { '' }
      let(:key) { '' }
      let(:dir) { @asc }
      include_context :parse_sort
    end
  end
end

