FactoryGirl.define do
  factory(:user) do
    sequence(:username)   { |n| "user#{n}" }
    email                 { "#{username}@example.com" }
    password              { ('a'..'z').to_a.shuffle[0...8].join }
    password_confirmation { password }
  end
end
