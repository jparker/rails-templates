class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :username, :email, :password, :password_confirmation

  validates :username, presence: true, uniqueness: {case_sensitive: false}, length: {within: 2..32}
  validates :password, presence: {on: :create}, confirmation: true, length: {minimum: 6, allow_blank: true}
  validates :email, format: { with: /\A [^@\s]+ @ (?: (?:[-a-z0-9]+\.)+ [a-z]{2,}) \Z/ix }
end
