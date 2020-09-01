class User < ApplicationRecord
  # Include default users modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates_presence_of :account_type
  validates_presence_of :email
  validates_uniqueness_of :email
  validate :password_complexity
  validate :email_domain

  enum account_type: %i[student staff library_manager]

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def email_domain
    return if email.blank? || email =~ /^[A-Za-z0-9._%+-]+@university.com$/

    errors.add :email, 'Email domain requirement not met. Email should be from the *@university.com domain'
  end
end
