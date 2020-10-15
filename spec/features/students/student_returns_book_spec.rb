require 'rails_helper'

RSpec.describe 'Student returns book', type: :feature, js: true do
  let(:user) { users(:user_1) }

  fixtures :all

  before do
    Fine.destroy_all
    Loan.destroy_all
    user.update(password: '12342%asdfasdAD')
  end

  it 'allows the student to borrow and return book' do
    visit root_path
    expect(page).to have_content 'Log in'
    fill_in 'user_email', with: 'student_fixture@university.com'
    fill_in 'user_password', with: '12342%asdfasdAD'
    click_on 'Log in'

    expect(page).to have_content 'How to code'
    expect(page).to have_content 'How to dance'

    within 'table' do
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

  context 'when the student has an overdue loan' do
    let(:book) { books(:book_3) }
    let!(:loan) { Loan.create(book: book, user: user, borrowed_at: 1.year.ago) }

    before do
      visit root_path
      fill_in 'user_email', with: 'student_fixture@university.com'
      fill_in 'user_password', with: '12342%asdfasdAD'
      click_on 'Log in'
    end

    it 'forces the student to pay the fine before returning' do
      within 'table' do
        find('tr', text: 'How to code').click_link('Show')
      end

      # Go to book show page
      expect(page).to have_current_path book_path(books(:book_3))
      expect(page).not_to have_button 'Return'
      expect(page).to have_text 'This loan is overdue, you must pay $1760 AUD'
      expect(page).not_to have_button 'Pay fine'

      click_on 'Pay fine'
      expect(page).to have_text 'Fine has been paid and the book has been returned successfully.'
    end

    it 'does not allow the student to borrow another book' do
      within 'table' do
        find('tr', text: 'How to dance').click_link('Show')
      end

      # Go to book show page
      expect(page).to have_current_path book_path(books(:book_4))
      expect(page).not_to have_button 'Return'
      expect(page).not_to have_button 'Pay fine'
      expect(page).not_to have_text 'This loan is overdue, you must pay $1760 AUD'
      expect(page).to have_text 'You cannot borrow this book as you have an overdue loan which needs to be returned.'
    end
  end
end
