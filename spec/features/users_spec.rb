require 'rails_helper'

describe 'ユーザー登録のシステムテスト', type: :feature do
  before do
    visit new_user_path
  end

  describe '無効なユーザー登録の場合' do
    before do
      fill_in '名前', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード確認', with: ''
      click_button '新規登録'
    end

    it '失敗メッセージが表示されること' do
      expect(page).to have_content '登録に失敗しました。正しく入力してください'
    end
    it '新規登録が表示されること' do
      expect(page).to have_content '新規登録'
    end
  end
end