class Book < ApplicationRecord
  has_many :loans
  has_one_attached :cover_image
  has_one_attached :content

  validates_presence_of :title, :author, :reference_number, :book_type
  validates :cover_image,
            attached: true,
            dimension: {
              width: { min: 100, max: 300 },
              height: { min: 100, max: 300 },
              message: 'is not given between dimension. Height between 100 and 300, width between 100 and 300.'
            }
  validates :cover_image, content_type: /\Aimage\/.*\z/
  validates :content, attached: true, content_type: { in: 'application/pdf', message: 'is not a PDF' }

  enum book_type: %i[book journal research_paper article]

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
