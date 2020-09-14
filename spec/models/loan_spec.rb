require 'rails_helper'

RSpec.describe Loan, type: :model do
  fixtures :users, :books, :loans

  subject { Loan.new(user: users(:user_1), book: books(:book_3), borrowed_at: 1.minute.ago) }

  it { is_expected.to validate_presence_of :borrowed_at }

  describe '.on_loan' do
    subject(:on_load) { described_class.on_loan }

    it { is_expected.to eq [loans(:loan_2)] }

    context 'when the document has been returned' do
      before { Loan.update_all(returned_at: 5.minutes.ago) }

      it { is_expected.to eq [] }
    end
  end

  describe '.returned' do
    subject(:returned) { described_class.returned }

    it { is_expected.to eq [] }

    context 'when the document has been returned' do
      before { Loan.update_all(returned_at: 5.minutes.ago) }

      it { is_expected.to eq [loans(:loan_2)] }
    end
  end
end
