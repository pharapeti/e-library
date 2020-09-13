require 'rails_helper'

RSpec.describe Fine, type: :model do
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
  let(:loan) { Loan.create(user: user, book: book, borrowed_at: 1.minute.ago) }
  subject { Fine.new(loan: loan, amount: 50) }

  it { is_expected.to validate_presence_of :amount }
end
