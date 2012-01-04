class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :username, :email, :password, :password_confirmation

  before_validation :normalize_username, :normalize_email

  validates :username, uniqueness: {case_sensitive: false}, length: {within: 2..32}
  validates :password, presence: {on: :create}, confirmation: true, length: {minimum: 6, allow_blank: true}
  validates :email, format: { with: /\A [^@\s]+ @ (?: (?:[-a-z0-9]+\.)+ [a-z]{2,}) \Z/ix }

  private
  def normalize_username
    self.username = username.try(:downcase).try(:strip)
  end

  def normalize_email
    self.email = email.try(:downcase)
  end
end
