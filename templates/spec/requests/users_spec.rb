require 'spec_helper'

describe 'Users' do
  describe 'listing users' do
    let!(:users) { create_list(:user, 5) }

    it 'lists users' do
      visit users_path
      users.each do |user|
        page.should have_selector('tbody tr.user td', text: user.username)
      end
    end

    context 'with many users' do
      before { create_list(:user, 25) }

      it 'paginates user list' do
        visit users_path
        page.should have_xpath("//a[@href='#{users_path(page: 2)}']", text: 'Next')
      end
    end
  end

  describe 'displaying an individual user' do
    let!(:user) { create(:user) }

    it 'displays details about user' do
      visit users_path
      click_link user.username
      page.should have_content(user.username)
      page.should have_xpath("//a[@href='mailto:#{user.email}']")
    end
  end

  describe 'creating a new user' do
    describe 'with valid attributes' do
      it "creates the user and redirects to the new user's page" do
        visit users_path
        click_link 'New user'
        fill_in 'Username', with: 'bob'
        fill_in 'Email', with: 'bob@example.com'
        fill_in 'Password', with: 'secret'
        fill_in 'Confirm password', with: 'secret'
        click_button 'Create User'

        user = User.find_by_username!('bob')
        current_path.should == user_path(user)
        page.should have_content('User was successfully created')
        user.email.should == 'bob@example.com'
      end
    end

    describe 'with invalid attributes' do
      it 're-renders the form and displays error messages' do
        visit users_path
        click_link 'New user'
        fill_in 'Username', with: 'a'
        fill_in 'Email', with: 'bogus'
        fill_in 'Password', with: ''
        fill_in 'Confirm password', with: ''
        click_button 'Create User'

        page.should have_content('User could not be created (see errors below)')
        page.should have_content('is too short')
        page.should have_content('is invalid')
        page.should have_content("can't be blank")
      end
    end
  end

  describe 'updating an existing user' do
    let!(:user) { create(:user, username: 'bob', email: 'bob@example.com') }

    describe 'with valid attributes' do
      it "updates the user and redirects to the user's page" do
        visit users_path
        click_link user.username
        click_link 'Edit user'
        fill_in 'Username', with: 'john'
        fill_in 'Email', with: 'john@example.com'
        click_button 'Update User'

        user.reload
        current_path.should == user_path(user)
        page.should have_content('User was successfully updated')
        user.username.should == 'john'
        user.email.should == 'john@example.com'
      end
    end

    describe 'with invalid attributes' do
      let!(:other_user) { create(:user) }

      it 're-renders the form and displays error messages' do
        visit users_path
        click_link user.username
        click_link 'Edit user'
        fill_in 'Username', with: other_user.username
        fill_in 'Email', with: 'bogus'
        fill_in 'Password', with: 'frizzle'
        fill_in 'Confirm password', with: 'frazzle'
        click_button 'Update User'

        page.should have_content('User could not be updated (see errors below)')
        page.should have_content('has already been taken')
        page.should have_content('is invalid')
        page.should have_content("doesn't match confirmation")
      end
    end
  end

  describe 'destroying an existing user' do
    let!(:user) { create(:user) }

    it 'destroys the user and redirects to the users index' do
      visit users_path
      click_link user.username
      click_link 'Delete user'

      current_path.should == users_path
      page.should have_content('User was successfully removed')
      User.should_not exist(user)
    end
  end
end
