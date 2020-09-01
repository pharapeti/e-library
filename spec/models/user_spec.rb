require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(account_type: :student) }

  it { is_expected.to validate_presence_of :account_type }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }

  it { is_expected.to define_enum_for(:account_type).with_values(%i[student staff library_manager]) }
end
