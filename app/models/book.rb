class Book < ApplicationRecord
  has_many :loans

  validates_presence_of :title, :author, :reference_number, :book_type

  enum book_type: %i[book journal research_paper article]

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
