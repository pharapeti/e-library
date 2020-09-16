require 'rails_helper'

RSpec.describe Fine, type: :model do
  fixtures :users, :books, :loans, :fines

  subject { fines(:fine_1) }

  it { is_expected.to validate_presence_of :amount }

  describe '.paid' do
    subject(:paid) { described_class.paid }

    it { is_expected.to eq [] }

    context 'when the fine has been paid' do
      before { fines(:fine_1).update(charged_at: 5.minutes.ago) }

      it { is_expected.to eq [fines(:fine_1)] }
    end
  end

  describe '.unpaid' do
    subject(:paid) { described_class.unpaid }

    it { is_expected.to eq [fines(:fine_1)] }

    context 'when the fine has been paid' do
      before { fines(:fine_1).update(charged_at: 5.minutes.ago) }

      it { is_expected.to eq [] }
    end
  end
end
