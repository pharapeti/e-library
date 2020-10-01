class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_one :fine

  validates_presence_of :borrowed_at

  scope :on_loan, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }

  def to_be_returned_at
    if renewed_at.nil?
      borrowed_at + 2.weeks
    else 
      borrowed_at = renewed_at + 2.weeks
    end
  end
end
