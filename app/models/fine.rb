class Fine < ApplicationRecord
  belongs_to :loan, optional: true

  validates_presence_of :amount

  scope :paid, -> { where.not(charged_at: nil) }
  scope :unpaid, -> { where(charged_at: nil) }
end
