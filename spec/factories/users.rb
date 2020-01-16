FactoryBot.define do 
  factory :user do 
      name {"aka"}
      sequence(:email) { |n| "aka#{n}@example.com"}
      password {"password"}
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images.jpg')) }
  end 

  factory :test_user, class: User do
    name { "デモ用ユーザー" }
    email { "test_user@example.com" }
    password { "password" }
  end
end 
