module AuthenticationMacros
  def sign_in_as(username, password)
    sign_out
    visit sign_in_path
    fill_in 'Username', with: username
    fill_in 'Password', with: password
    click_button 'Sign in'
  end

  def sign_in
    user = create(:user, password: 'secret')
    sign_in_as(user.username, 'secret')
  end

  def sign_out
    visit sign_out_path
  end
end
