FactoryBot.define do
  factory :user do
    name { "Alexandr_#{rand(2001)}" }

    sequence(:email) { |n| "someone_#{n}@example.com" }

    is_admin { false }

    balance { 0 }

    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end
