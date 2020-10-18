class User < ApplicationRecord
  # Include default users modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :loans
  has_many :books, through: :loans
  has_many :book_requests

  validates_presence_of :account_type
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :password_complexity
  validate :email_domain

  enum account_type: %i[student staff library_manager]

  def has_overdue_loans?
    loans.on_loan.any? { |loan| loan.overdue? }
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,70}$/

    errors.add :password, 'Complexity requirement not met. Length should be 6-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def email_domain
    return if email.blank? || email =~ /^[A-Za-z0-9._%+-]+@university.com$/

    errors.add :email, 'Email domain requirement not met. Email should be from the *@university.com domain'
  end
end
