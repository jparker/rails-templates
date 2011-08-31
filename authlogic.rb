# TODO: view spec for sign in form? call #active_authlogic in spec_helper? copy shoulda_macros/authlogic.rb
generate 'authlogic:session', 'user_session'
generate :model, 'user', 'username:string', 'name:string', 'email:string', 'crypted_password:string', 'password_salt:string', 'persistence_token:string'
migration_file = Dir["db/migrate/*_create_users.rb"].first
gsub_file migration_file,
  /\.string :(username|name|email|crypted_password|password_salt|persistence_token)/,
  '.string :\1, null: false'
# BUG: #inject_into_file only works on the first of the calls below (regardless of order)
# inject_into_file migration_file, ', null: false', after: ':username'
# inject_into_file migration_file, ', null: false', after: ':name'
# inject_into_file migration_file, ', null: false', after: ':email'
# inject_into_file migration_file, ', null: false', after: ':crypted_password'
# inject_into_file migration_file, ', null: false', after: ':password_salt'
# inject_into_file migration_file, ', null: false', after: ':persistence_token'
inject_into_file migration_file,
                 "    add_index :users, :username, unique: true\n    add_index :users, :persistence_token\n",
                 after: "t.timestamps\n    end\n"

macros_file = File.expand_path(File.join(File.dirname(`gem which authlogic`.chomp), '..', 'shoulda_macros', 'authlogic.rb'))
FileUtils.mkdir_p File.join('spec', 'support')
FileUtils.cp macros_file, File.join('spec', 'support', 'authlogic.rb')

prepend_to_rspec_config_block <<RUBY
  # speed up password encryption during testing
  config.before(:suite) { Authlogic::CryptoProviders::BCrypt.cost = 1 }
RUBY

gsub_file 'spec/models/user_spec.rb', /  pending ".*"/, <<RUBY
  include Authlogic::Shoulda::Matchers

  it { should have_authlogic }
RUBY
inject_into_class 'app/models/user.rb', 'User', "  acts_as_authentic\n"

inject_into_file 'app/controllers/application_controller.rb', <<RUBY, after: "protect_from_forgery\n"
  helper_method :current_user_session, :current_user

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session.try(:user)
  end

  def require_user
    unless current_user
      flash[:notice] = 'You must be signed in.'
      redirect_to sign_in_url
      return false
    end
  end
RUBY

file 'spec/routing/user_sessions_spec.rb', <<RUBY
require 'spec_helper'

describe UserSessionsController do
  describe 'routing' do
    it 'recognizes and generates #new' do
      { get: '/user_session/new' }.should route_to('user_sessions#new')
      { get: '/sign_in' }.should route_to('user_sessions#new')
    end

    it 'recognizes and generates #create' do
      { post: '/user_session' }.should route_to('user_sessions#create')
    end

    it 'recognizes and generates #destroy' do
      { delete: '/user_session' }.should route_to('user_sessions#destroy')
      { get: '/sign_out' }.should route_to('user_sessions#destroy')
    end
  end
end
RUBY
route 'resource :user_session, only: [:new, :create, :destroy]'
route "match '/sign_in' => 'user_sessions#new', as: :sign_in"
route "match '/sign_out' => 'user_sessions#destroy', as: :sign_out"
todo 'authlogic', 'configure root_path in config/routes.rb and remove public/index.html'

file 'spec/factories/users.rb', <<RUBY
FactoryGirl.define do
  factory(:user) do
    sequence(:username) { |i| "user\#{i}" }
    name { Faker::Name.name }
    email { "\#{username}@example.com" }
    password { ('a'..'z').to_a.shuffle[0...8].join }
    password_confirmation { password }
  end
end
RUBY

file 'spec/requests/user_sessions_spec.rb', <<RUBY
require 'spec_helper'

describe 'UserSessions' do
  before do
    # User FactoryGirl.build and User#save_without_session_maintenance to work around
    # a problem between Rails 3.1 streaming and Authlogic
    user = build(:user, username: 'remy', password: 'secret')
    user.save_without_session_maintenance
  end

  describe 'POST /user_sessions' do
    it 'redirects to home page after successfully signing in' do
      visit sign_in_path
      fill_in 'Username', with: 'remy'
      fill_in 'Password', with: 'secret'
      click_button 'Sign in'

      current_path.should == root_path
      page.should have_content('You are now signed in')
    end

    it 're-renders the sign in form after failing to sign in' do
      visit sign_in_path
      fill_in 'Username', with: 'remy'
      fill_in 'Password', with: ''
      click_button 'Sign in'

      current_path.should == user_session_path
      page.should have_content('You entered an invalid username or password')
      page.should have_css('input#user_session_username')
      page.should have_css('input#user_session_password')
    end
  end

  describe 'DELETE /user_sessions' do
    before do
      visit sign_in_path
      fill_in 'Username', with: 'remy'
      fill_in 'Password', with: 'secret'
      click_button 'Sign in'
    end

    it 'redirects to sign in page after signing out' do
      visit root_path
      click_link 'Sign out'

      current_path.should == sign_in_path
      page.should have_content('You are now signed out')
    end
  end
end
RUBY

file 'app/controllers/user_sessions_controller.rb', <<RUBY
class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'You are now signed in.'
      redirect_to root_url
    else
      flash[:error] = 'You entered an invalid username or password.'
      render 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'You are now signed out.'
    redirect_to sign_in_url
  end
end
RUBY

file 'app/views/user_sessions/new.html.haml', <<HAML
= form_for @user_session, url: user_session_path do |f|
  %p
    = f.label :username
    = f.text_field :username
  %p
    = f.label :password
    = f.password_field :password
  %p
    = f.submit 'Sign in'
HAML
