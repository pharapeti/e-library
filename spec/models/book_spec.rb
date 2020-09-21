require 'rails_helper'

RSpec.describe Book, type: :model do
  fixtures :books

  subject do
    Book.new(
      title: 'How to code',
      author: 'Peter Krauss',
      reference_number: '102A',
      edition: '16th',
      book_type: :journal,
      active: true
    )
  end

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :author }
  it { is_expected.to validate_presence_of :reference_number }
  it { is_expected.to validate_presence_of :book_type }

  it { expect(subject).to define_enum_for(:book_type).with_values(%i[book journal research_paper article]) }

  describe '.active' do
    subject(:active) { described_class.active }

    it { is_expected.to eq [books(:book_3), books(:book_4)] }

    context 'when the books arent active' do
      before { Book.all.update_all(active: false) }

      it { is_expected.to eq [] }
    end
  end

  describe '.inactive' do
    subject(:inactive) { described_class.inactive }

    it { is_expected.to eq [] }

    context 'when the books arent active' do
      before { Book.all.update_all(active: false) }

      it { is_expected.to eq [books(:book_3), books(:book_4)] }
    end
  end
end
