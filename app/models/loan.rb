class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_one :fine

  validates_presence_of :borrowed_at

  scope :on_loan, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }

  def to_be_returned_at
    (renewed_at || borrowed_at) + 2.weeks
  end

  def overdue?
    Date.today > to_be_returned_at
  end

  def amount_pending
    return unless Date.today > to_be_returned_at + 1.week # 1 week grace period

    Fine::AMOUNT_PER_DAY * (Date.today - to_be_returned_at.to_date).to_i
  end
end
