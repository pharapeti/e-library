class Fine < ApplicationRecord
  belongs_to :loan, optional: true

  AMOUNT_PER_DAY = 5 # AUD dollars per day overdue

  validates_presence_of :amount

  scope :paid, -> { where.not(charged_at: nil) }
  scope :unpaid, -> { where(charged_at: nil) }

  def amount_pending
    return unless Date.today > loan.to_be_returned_at + 1.week # 1 week grace period

    AMOUNT_PER_DAY * (Date.today - loan.to_be_returned_at.to_date).to_i
  end
end
