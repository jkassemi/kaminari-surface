require 'spec_helper'
require 'kaminari/surface/page_scope_methods'
require 'kaminari/models/array_extension'
require 'pry'

RSpec.describe Kaminari::Surface::PageScopeMethods do
  let(:items) do
    Kaminari::PaginatableArray.new((1..23).to_a)
  end

  describe '#per' do
    context 'when called after surface' do
      subject { ->{ items.page(1).surface(5).per(5) }}

      it 'should raise an `ArgumentError`' do
        expect(subject).to raise_error(ArgumentError)
      end
    end
  end

  describe '#padding' do
    context 'when called after surface' do
      subject { ->{ items.page(1).surface(5).padding(5) }}

      it 'should raise an `ArgumentError`' do
        expect(subject).to raise_error(ArgumentError)
      end
    end
  end

  describe '#surface' do
    context 'when requesting first page with 0 surface' do
      subject { items.page(1).per(5).surface(0) }

      it 'has offset 0' do
        expect(subject.offset_value).to eq(0)
      end

      it 'has limit 5' do
        expect(subject.limit_value).to eq(5)
      end
    end

    context 'when requesting last page with 0 surface' do
      subject { items.page(5).per(5).surface(0) }

      it 'has offset 20' do
        expect(subject.offset_value).to eq(20)
      end

      it 'has limit 5' do
        expect(subject.limit_value).to eq(5)
      end
    end

    context 'when requesting first page with 3 surface' do
      subject { items.page(1).per(5).surface(3) }

      it 'has offset 0' do
        expect(subject.offset_value).to eq(0)
      end

      it 'has limit 5' do
        expect(subject.limit_value).to eq(5)
      end
    end

    context 'when requesting last page with 3 surface' do
      subject { items.page(4).per(5).surface(3) }

      it 'has offset 15' do
        expect(subject.offset_value).to eq(15)
      end

      it 'has limit 8' do
        expect(subject.limit_value).to eq(8)
      end
    end
  end

  # The implementation of `current_page` in the surfacing extension uses a stored `per_page`
  # value instead of the `limit_value` used in the original kaminari version since the limit
  # value may be modified by `surface`.
  describe '#current_page' do
    context 'when surfacing results on the last page' do
      subject { items.page(4).per(5).surface(5).current_page }
      it { is_expected.to be(4) }
    end

    context 'when we exceeded the page count' do
      subject { items.page(5).per(5).surface(5).current_page }
      it { is_expected.to be(5) } # Still respond, but empty result set
    end
  end

  describe '#total_pages' do
    context 'when surfacing results' do
      subject { items.page(1).per(5).surface(5).total_pages }
      it { is_expected.to be(4) }
    end

    context 'without surfacing' do
      subject { items.page(1).per(5).total_pages }
      it { is_expected.to be(5) }
    end

    context 'with 0 surface' do
      subject { items.page(1).per(5).surface(0).total_pages }
      it { is_expected.to be(5) }
    end
  end

  describe '#num_pages' do
    context 'when surfacing results' do
      subject { items.page(1).per(5).surface(5).num_pages }
      it { is_expected.to be(4) }
    end

    context 'without surfacing' do
      subject { items.page(1).per(5).num_pages }
      it { is_expected.to be(5) }
    end

    context 'with 0 surface' do
      subject { items.page(1).per(5).surface(0).num_pages }
      it { is_expected.to be(5) }
    end
  end
end
