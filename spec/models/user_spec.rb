require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  subject { User.create(email: 'testme@university.com', account_type: :student, password: '123@34adjsadA') }

  it { is_expected.to validate_presence_of :account_type }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { is_expected.to define_enum_for(:account_type).with_values(%i[student staff library_manager]) }
end
