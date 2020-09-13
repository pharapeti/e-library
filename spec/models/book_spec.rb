require 'rails_helper'

RSpec.describe Book, type: :model do
  subject do
    Book.new(
      title: 'How to code',
      author: 'Peter Krauss',
      reference_number: '102A',
      edition: '16th',
      book_type: :journal,
      active: true
    )
  end

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :author }
  it { is_expected.to validate_presence_of :reference_number }
  it { is_expected.to validate_presence_of :book_type }

  it { expect(subject).to define_enum_for(:book_type).with_values(%i[book journal research_paper article]) }
end
