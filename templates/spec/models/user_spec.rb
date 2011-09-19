require 'spec_helper'

describe User do
  it { should allow_mass_assignment_of(:username) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }

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

    context 'password confirmation' do
      subject { build(:user, password_confirmation: 'frizzle') }
      it { should allow_value('frizzle').for(:password) }
      it { should_not allow_value('frazzle').for(:password) }
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
