require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:user) { User.create(email: 'bruh@university.com', password: '12342%asdfasdAD', account_type: :student) }
  let(:book) do
    Book.create(
      title: 'How to code',
      author: 'Peter Krauss',
      reference_number: '102A',
      edition: '16th',
      book_type: :journal,
      active: true
    )
  end
  subject { Loan.new(user: user, book: book, borrowed_at: 1.minute.ago) }

  it { is_expected.to validate_presence_of :borrowed_at }

  describe '.on_loan' do
    let!(:loan) { Loan.create(user: user, book: book, borrowed_at: 1.month.ago, returned_at: returned_at) }
    let(:returned_at) { nil }

    subject(:on_load) { described_class.on_loan }

    it { is_expected.to eq [loan] }

    context 'when the document has been returned' do
      let(:returned_at) { 5.minutes.ago }

      it { is_expected.to eq [] }
    end
  end

  describe '.returned' do
    let!(:loan) { Loan.create(user: user, book: book, borrowed_at: 1.month.ago, returned_at: returned_at) }
    let(:returned_at) { nil }

    subject(:on_load) { described_class.returned }

    it { is_expected.to eq [] }

    context 'when the document has been returned' do
      let(:returned_at) { 5.minutes.ago }

      it { is_expected.to eq [loan] }
    end
  end
end
