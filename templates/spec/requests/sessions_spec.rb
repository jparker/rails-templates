require 'spec_helper'

describe 'Sessions' do
  let!(:user) { create(:user, username: 'bob', password: 'secret') }

  describe 'signing in' do
    it 'redirects to home page on success' do
      visit sign_in_path
      fill_in 'Username', with: 'bob'
      fill_in 'Password', with: 'secret'
      click_button 'Sign in'
      current_path.should == root_path
      page.should have_content('You are now signed in')
    end

    it 're-renders the sign in form after failure' do
      visit sign_in_path
      fill_in 'Username', with: 'bob'
      fill_in 'Password', with: 'bogus'
      click_button 'Sign in'
      current_path.should == session_path
      page.should have_content('The username or password you entered was invalid')
      page.should have_css('input#username')
      page.should have_css('input#password')
    end
  end

  describe 'signing out' do
    before { sign_in_as('bob', 'secret') }

    it 'redirects to sign in page after signing out' do
      visit root_path
      click_link 'Sign out'
      current_path.should == sign_in_path
      page.should have_content('You are now signed out')
    end
  end
end
