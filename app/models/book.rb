class Book < ApplicationRecord
  has_many :loans
  has_one_attached :cover_image

  validates_presence_of :title, :author, :reference_number, :book_type
  validates :cover_image,
            attached: true,
            dimension: {
              width: { min: 600, max: 1000 },
              height: { min: 400, max: 800 },
              message: 'is not given between dimension. Height between 400 and 800, width between 600 and 1000.'
            }
  validates :cover_image, content_type: /\Aimage\/.*\z/

  enum book_type: %i[book journal research_paper article]

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
