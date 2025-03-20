FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password1234" }
    password_confirmation { "password1234" }
  end
end
