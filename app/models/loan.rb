class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_one :fine

  validates_presence_of :borrowed_at
end
