require 'rails_helper'

RSpec.describe 'Student borrows book', type: :feature, js: true do
  let(:user) { users(:user_1) }

  fixtures :all

  before do
    Fine.destroy_all
    Loan.destroy_all
    user.update(password: '12342%asdfasdAD')
  end

  it 'allows the student to borrow a book' do
    visit root_path
    expect(page).to have_content 'Log in'
    fill_in 'user_email', with: 'student_fixture@university.com'
    fill_in 'user_password', with: '12342%asdfasdAD'
    click_on 'Log in'

    expect(page).to have_content 'How to code'
    expect(page).to have_content 'How to dance'

    within 'table#books_list' do
      find('tr', text: 'How to code').click_link('Show')
    end

    # Go to book show page and borrow a book
    expect(page).to have_current_path book_path(books(:book_3))
    click_on 'Borrow book'
    expect(page).to have_text 'Book was borrowed successfully.'
    expect(page).to have_text 'About your loan'
    expect(page).to have_text 'Borrowed at:'
    expect(page).to have_text 'To be returned at:'

    # Now return the book
    click_on 'Return book'
    expect(page).to have_text 'Book was successfully returned.'
  end
end
