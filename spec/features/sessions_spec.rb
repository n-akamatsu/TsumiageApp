require 'rails_helper'

describe 'ユーザーログイン機能', type: :feature do
  let(:user) { FactoryBot.create :user }
  before do
    create(:tsumiage, user: user)
  end
  before { visit login_path }

  context '有効なログイン' do
    it 'ホームページに移動' do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
      expect(page).to have_content 'みんなの積み上げ'
    end
  end

  context '無効なログイン' do
    it 'メールアドレスが無効である' do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'

      expect(page).to have_content 'メールアドレスもしくはパスワードが間違っています'
    end

    it 'パスワードが無効である' do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: ''
      click_button 'ログイン'

      expect(page).to have_content 'メールアドレスもしくはパスワードが間違っています'
    end
  end
end