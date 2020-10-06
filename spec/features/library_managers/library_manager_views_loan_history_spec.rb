require 'rails_helper'

RSpec.describe 'Library Manager views loan history', type: :feature, js: true do
  let(:user) { users(:user_3) }

  fixtures :all

  before do
    user.update(password: '12342%asdfasdAD')
  end

  it 'allows the library manager to view the loan history' do
    visit root_path
    expect(page).to have_content 'Log in'
    fill_in 'user_email', with: 'library_manager@university.com'
    fill_in 'user_password', with: '12342%asdfasdAD'
    click_on 'Log in'

    expect(page).to have_content 'How to code'
    expect(page).to have_content 'How to dance'

    within 'table' do
      find('tr', text: 'How to code').click_link('Show')
    end

    # Check Loan History 
    expect(page).to have_current_path book_path(books(:book_3))
    expect(page).to have_text 'Loan History'
    expect(page).to have_text 'User ID'
    expect(page).to have_text 'Borrow date'
    expect(page).to have_text 'Return date'
    expect(page).to have_text 'Late return'
    expect(page).to have_text 'Fine'
  end
end
