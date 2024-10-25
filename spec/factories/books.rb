FactoryBot.define do
  factory :book do
    title { "MyString" }
    read { false }
    # Search for factory traits or sub factories to complete these file

    trait :pending do
      pending_approval {true}
    end

    trait :nonpending do
      pending_approval {false}
    end
  end
end
