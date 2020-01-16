require 'rails_helper'

RSpec.describe User, type: :model do

  it "有効なファクトリをもつ" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "ユーザーネーム、メール、パスワードがあればユーザーは有効な状態である" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "ユーザーネームがなければ無効な状態である" do
    user = FactoryBot.build(:user, name: nil)
    expect(user.valid?).to eq(false)
  end

  it "ユーザーネームが50文字以上であれば無効な状態である" do
    user = FactoryBot.build(:user, name: "a" * 51)
    expect(user.valid?).to eq(false)
  end

  it "メールアドレスがなければ無効な状態である" do
    user = FactoryBot.build(:user, email: nil)
    expect(user.valid?).to eq(false)
  end

  it "メールアドレスが重複していれば無効な状態である" do
    user1 = FactoryBot.create(:user, email: "sample@example.com")
    user2 = FactoryBot.build(:user, email: "sample@example.com")
    expect(user2.valid?).to eq(false)
  end

  it "パスワードが空であれば無効な状態である" do
    user = FactoryBot.build(:user, password: " " * 6)
    expect([:password]).to include(:password)
  end

  it "パスワードが5文字以下であれば無効な状態である" do
    user = FactoryBot.build(:user, password: "a" * 5)
    expect([:password]).to include(:password)
  end
end