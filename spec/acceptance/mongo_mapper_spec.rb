require 'spec_helper'

RSpec.describe 'MongoMapper integration' do
  before(:context) do
    SampleModels::MongoMapper::Widget.delete_all
    23.times { SampleModels::MongoMapper::Widget.create }
  end

  context 'first page when no surfacing requested' do
    subject(:widgets) { SampleModels::MongoMapper::Widget.page(1).per(5) }

    it 'has 5 pages' do
      expect(widgets.total_pages).to eq(5)
    end

    it 'has 5 widgets' do
      expect(widgets.to_a.size).to eq(5)
    end

    it 'has 23 total widgets' do
      expect(widgets.total_count).to eq(23)
    end
  end

  context 'first page when surfacing is 0' do
    subject(:widgets) { SampleModels::MongoMapper::Widget.page(1).per(5) }

    it 'has 5 pages' do
      expect(widgets.total_pages).to eq(5)
    end
  end

  context 'first page when surfacing is 3' do
    subject(:widgets) { SampleModels::MongoMapper::Widget.page(1).per(5).surface(3) }

    it 'has 4 pages' do
      expect(widgets.total_pages).to eq(4)
    end

    it 'has 5 widgets' do
      expect(widgets.to_a.size).to eq(5)
    end
  end

  context 'last page when surfacing is 3' do
    subject(:widgets){ SampleModels::MongoMapper::Widget.page(4).per(5).surface(3) }

    it 'has 8 widgets' do
      expect(widgets.to_a.size).to eq(8)
    end
  end

  context 'last page when surfacing is 8 (per + remainder)' do
    subject(:widgets) { SampleModels::MongoMapper::Widget.page(3).per(5).surface(8) }

    it 'has 3 pages' do
      expect(widgets.total_pages).to eq(3)
    end

    it 'has 13 widgets' do
      expect(widgets.to_a.size).to eq(13)
    end

    it 'has 23 total widgets' do
      expect(widgets.total_count).to eq(23)
    end
  end

  context 'when `per` is called after `surface`' do
    subject(:widgets){ ->{ SampleModels::MongoMapper::Widget.page(1).surface(5).per(5) } }

    it 'should raise an `ArgumentError`' do
      expect(subject).to raise_error(ArgumentError)
    end
  end

  context 'when `padding` is called after `surface`' do
    subject(:widgets){ ->{ SampleModels::MongoMapper::Widget.page(1).surface(5).padding(5) } }

    it 'should raise an `ArgumentError`' do
      expect(subject).to raise_error(ArgumentError)
    end
  end
end
