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
end
