class User < ApplicationRecord
  # Include default users modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates_presence_of :account_type
  validates_presence_of :email
  validates_uniqueness_of :email

  enum account_type: %i[student staff library_manager]
end
