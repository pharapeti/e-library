require 'rails_helper'

RSpec.describe 'Staff account registration', type: :feature, js: true do
  it 'allows the user to register an account' do
    visit root_path
    expect(page).to have_content 'Log in'
    click_on 'Sign up'

    # Fill out account registration form
    expect(page).to have_content 'Sign up'
    fill_in 'user_email', with: 'test@university.com'
    fill_in 'user_password', with: '@#123fsahfhsWer'
    fill_in 'user_password_confirmation', with: '@#123fsahfhsWer'
    select 'Staff', from: 'user_account_type'
    click_on 'Sign up'
    expect(page).to have_content <<~TEXT.squish
      A message with a confirmation link has been sent to your email address.
      Please follow the link to activate your account.
    TEXT

    # Confirm the account
    visit user_confirmation_path(confirmation_token: User.last.reload.confirmation_token)
    expect(page).to have_content 'Your email address has been successfully confirmed.'
    expect(page).to have_content 'Log in'

    # Log into confirmed account
    fill_in 'user_email', with: 'test@university.com'
    fill_in 'user_password', with: '@#123fsahfhsWer'
    click_on 'Log in'

    # Staff member is now at homepage
    expect(page).to have_current_path staff_dashboard_path
    click_on 'Log out'

    # User signs out
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in'
  end

  context 'when the user tries to log in before confirming their email' do
    it 'allows the user to register an account' do
      visit root_path
      expect(page).to have_content 'Log in'
      click_on 'Sign up'

      # Fill out account registration form
      expect(page).to have_content 'Sign up'
      fill_in 'user_email', with: 'test@university.com'
      fill_in 'user_password', with: '@#123fsahfhsWer'
      fill_in 'user_password_confirmation', with: '@#123fsahfhsWer'
      select 'Staff', from: 'user_account_type'
      click_on 'Sign up'
      expect(page).to have_content <<~TEXT.squish
        A message with a confirmation link has been sent to your email address.
        Please follow the link to activate your account.
      TEXT

      # Try to log in
      expect(page).to have_content 'Log in'
      fill_in 'user_email', with: 'test@university.com'
      fill_in 'user_password', with: '@#123fsahfhsWer'
      click_on 'Log in'

      # Does not allow the user to log in
      expect(page).to have_content 'Log in'
      expect(page).to have_current_path new_user_session_path
      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end
  end

  context 'when an User with the same email address already exists' do
    before { User.create(email: 'taken@university.com', account_type: :staff, password: '@#123fsahfWer') }

    it 'shows an error' do
      visit root_path
      expect(page).to have_content 'Log in'
      click_on 'Sign up'

      # Fill out account registration form
      expect(page).to have_content 'Sign up'
      fill_in 'user_email', with: 'taken@university.com'
      fill_in 'user_password', with: '@#123fsahfhsWer'
      fill_in 'user_password_confirmation', with: '@#123fsahfhsWer'
      select 'Staff', from: 'user_account_type'
      click_on 'Sign up'

      # Displays error
      within '.input.user_email' do
        expect(page).to have_content 'has already been taken'
      end
    end
  end

  context 'when the user tries to create an account with a weak password' do
    it 'shows an error' do
      visit root_path
      expect(page).to have_content 'Log in'
      click_on 'Sign up'

      # Fill out account registration form
      expect(page).to have_content 'Sign up'
      fill_in 'user_email', with: 'weak@university.com'
      fill_in 'user_password', with: '123456'
      fill_in 'user_password_confirmation', with: '123456'
      select 'Staff', from: 'user_account_type'
      click_on 'Sign up'

      # Displays error
      within '.input.user_password' do
        expect(page).to have_content <<~TEXT.squish
          Complexity requirement not met. 
          Length should be 6-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special
        TEXT
      end
    end
  end

  context 'when the user tries to create an account with an invalid email address' do
    it 'shows an error' do
      visit root_path
      expect(page).to have_content 'Log in'
      click_on 'Sign up'

      # Fill out account registration form
      expect(page).to have_content 'Sign up'
      fill_in 'user_email', with: 'invalid@example.com'
      fill_in 'user_password', with: '@#123fsahfhsWer'
      fill_in 'user_password_confirmation', with: '@#123fsahfhsWer'
      select 'Staff', from: 'user_account_type'
      click_on 'Sign up'

      # Displays error
      within '.input.user_email' do
        expect(page).to have_content 'Email domain requirement not met. Email should be from the *@university.com domain'
      end
    end
  end
end
