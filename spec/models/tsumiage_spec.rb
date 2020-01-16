require 'rails_helper'

RSpec.describe Tsumiage, type: :model do
  
  context '有効な情報が入力されたとき' do
    it '必要なデータが入力され、正常に登録できる' do
      tsumiage = build(:tsumiage)
      expect(tsumiage).to be_valid
    end
  end

  context '無効な情報が入力されたとき' do
    it 'timeがないためエラーになる' do
      tsumiage = build(:tsumiage, time: nil)
      expect(tsumiage.valid?).to eq(false)
    end

    it 'genreがないためエラーになる' do
      tsumiage = build(:tsumiage, genre: nil)
      expect(tsumiage.valid?).to eq(false)
    end

    it 'contentがないためエラーになる' do
      tsumiage = build(:tsumiage, content: nil)
      expect(tsumiage.valid?).to eq(false)
    end

    it 'contentが51文字以上でエラーになる' do
      tsumiage = build(:tsumiage, content: ('a' * 51))
      expect(tsumiage.valid?).to eq(false)
    end
  end
end