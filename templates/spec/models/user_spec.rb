require 'spec_helper'

describe User do
  it { should allow_mass_assignment_of(:username) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }

  describe 'before validation' do
    it 'normalizes username' do
      user = build(:user, username: ' WinsomeDangerParker ')
      user.valid?
      user.username.should eq('winsomedangerparker')
    end

    it 'normalizes email address' do
      user = build(:user, email: 'Winsome.Danger@Example.com')
      user.valid?
      user.email.should eq('winsome.danger@example.com')
    end
  end

  describe 'validation' do
    it { should validate_presence_of(:username) }
    it { should ensure_length_of(:username).is_at_least(2).is_at_most(32) }
    it { should ensure_length_of(:password).is_at_least(6) }
    it { should allow_value('bob@example.com').for(:email) }
    it { should allow_value('john.smith@gmail.com').for(:email) }
    it { should allow_value('arthur42@gmail.co.uk').for(:email) }
    it { should_not allow_value('bogus').for(:email) }
    it { should_not allow_value('john smith@gmail.com').for(:email) }
    it { should_not allow_value('bob@example').for(:email) }

    it 'validates confirmation of password' do
      user = build(:user)
      user.password, user.password_confirmation = 'frizzle', 'frazzle'
      user.should_not be_valid
      user.errors[:password].should include("doesn't match confirmation")
    end

    context 'when users exist' do
      before { create(:user) }
      it { should validate_uniqueness_of(:username).case_insensitive }
    end

    context 'on create' do
      subject { User.new }
      it { should validate_presence_of(:password) }
    end

    context 'on update' do
      subject { create(:user) }
      it { should_not validate_presence_of(:password) }
    end
  end
end
