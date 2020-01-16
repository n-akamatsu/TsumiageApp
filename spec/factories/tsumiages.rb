FactoryBot.define do
  factory :tsumiage do
    time {"60"}
    genre {"プログラミング"}
    sequence(:content) { |n| "test content#{n}" }
    user_id {"1"}
    association :user

    trait :invalid do
      time {nil}
      genre {nil}
      content {nil}
    end
  end
end