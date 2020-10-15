require 'rails_helper'

RSpec.feature "Users", type: :feature do
  context 'change user information' do

    before do
      User.create(
        email: 'test_user_changes@university.com', first_name: 'John', last_name: 'Smith',
        account_type: :staff, password: '@#123fsahfWer'
      )
      visit user_confirmation_path(confirmation_token: User.last.reload.confirmation_token)
    end

    it "should be successful" do
      visit root_path
      expect(page).to have_content 'Log in'
      fill_in 'user_email', with: 'test_user_changes@university.com'
      fill_in 'user_password', with: '@#123fsahfWer'
      click_on 'Log in'
      expect(page).to have_content "Signed in successfully."
      expect(page).to have_current_path staff_dashboard_path

      visit edit_user_registration_path
      within('form') do
        fill_in "First name",	with: "John"
        fill_in "Last name",	with: "Smith"
        fill_in "Email",	with: "test_user_changes@university.com"
        fill_in "Password",	with: "123456Aa!"
        fill_in "Password confirmation",	with: "123456Aa!"
        fill_in "Current password", with: "@#123fsahfWer"

        click_on 'Update'
      end

      expect(page).to have_current_path staff_dashboard_path
      expect(page).to have_text "Your account has been updated successfully."
    end

    context 'when passing invalid data to the form' do
      it "should not be successful" do
        visit root_path
        expect(page).to have_content 'Log in'
        fill_in 'user_email', with: 'test_user_changes@university.com'
        fill_in 'user_password', with: '@#123fsahfWer'
        click_on 'Log in'
        expect(page).to have_content "Signed in successfully."
        expect(page).to have_current_path staff_dashboard_path

        visit edit_user_registration_path
        within('form') do
          fill_in "First name",	with: "John"
          fill_in "Last name",	with: "Smith"
          fill_in "Email",	with: "test@gmail.com"
          fill_in "Password",	with: "555555555"
          fill_in "Password confirmation",	with: "555555556"
          fill_in "Current password", with: "baslghiaslfg"

          click_on 'Update'
        end

        expect(page).to have_current_path user_registration_path
        expect(page).to have_content <<~TEXT
          Email domain requirement not met. Email should be from the *@university.com domain
        TEXT
        expect(page).to have_content <<~TEXT.squish.gsub("\n", ' ')
          Complexity requirement not met. Length should be 6-70 characters and
          include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
        TEXT
        expect(page).to have_content "doesn't match Password"
        expect(page).to have_content "We need your current password to confirm your changes. is invalid"
      end
    end
  end
end