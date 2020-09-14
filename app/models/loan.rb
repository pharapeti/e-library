class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_one :fine

  validates_presence_of :borrowed_at

  scope :on_loan, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
end
