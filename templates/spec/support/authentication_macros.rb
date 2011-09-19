module AuthenticationMacros
  def sign_in_as(user)
    visit sign_in_path
    fill_in 'Username', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def sign_in
    sign_in_as(create(:user))
  end
end
