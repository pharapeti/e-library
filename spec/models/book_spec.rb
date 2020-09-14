require 'rails_helper'

RSpec.describe Book, type: :model do
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
    let!(:book) do
      Book.create(
        title: 'How to code',
        author: 'Peter Krauss',
        reference_number: '102A',
        edition: '16th',
        book_type: :journal,
        active: book_active
      )
    end
    let(:book_active) { false }

    subject(:active) { described_class.active }

    it { is_expected.to eq [] }

    context 'when the book is active' do
      let(:book_active) { true }

      it { is_expected.to eq [book] }
    end
  end

  describe '.inactive' do
    let!(:book) do
      Book.create(
        title: 'How to code',
        author: 'Peter Krauss',
        reference_number: '102A',
        edition: '16th',
        book_type: :journal,
        active: active
      )
    end
    let(:active) { false }

    subject(:inactive) { described_class.inactive }

    it { is_expected.to eq [book] }

    context 'when the book is active' do
      let(:active) { true }

      it { is_expected.to eq [] }
    end
  end
end
