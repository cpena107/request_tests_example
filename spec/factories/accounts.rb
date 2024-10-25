FactoryBot.define do
  factory :account do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :admin do
      role_id {1}
    end

    trait :normal do
      role_id {0}
    end
  end
end
