require 'rails_helper'

RSpec.describe 'Student renews book', type: :feature, js: true do
  let(:user) { users(:user_1) }

  fixtures :all

  before do
    Fine.destroy_all
    Loan.destroy_all
    user.update(password: '12342%asdfasdAD')
  end

  it 'allows the student to renew a book' do
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
    expect(page).to have_text 'Returned at:'
    expect(page).to have_text 'To be returned at:'

    # Renew book
    click_on 'Renew book'
    expect(page).to have_text 'Book was successfully renewed.'
    expect(page).to have_text 'About your loan'
    expect(page).to have_text 'Borrowed at:'
    expect(page).to have_text 'Renewed at:'
    expect(page).to have_text 'Returned at:'
    expect(page).to have_text 'To be returned at:'

  end

  context 'when the student has reached the renewal limit' do
    let(:book) { books(:book_3) }
    let!(:loan) { Loan.create(book: book, user: user, renewal_no: 4) }

    before do
      visit root_path
      fill_in 'user_email', with: 'student_fixture@university.com'
      fill_in 'user_password', with: '12342%asdfasdAD'
      click_on 'Log in'
    end

    it 'prevents the student to renew one more time' do
      within 'table#books_list' do
        find('tr', text: 'How to code').click_link('Show')
      end

      # Go to book show page
      expect(page).to have_current_path book_path(books(:book_3))
      expect(page).to have_text 'Renewed at:'
      expect(page).not_to have_button 'Renew book'

      click_on 'Renew book'
      expect(page).to have_text 'Failed to renew book. You have reached the renewal limit.'
    end
  end
end
