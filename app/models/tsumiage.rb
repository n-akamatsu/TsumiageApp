class Tsumiage < ApplicationRecord
  attr_accessor :more_tsumiage

  belongs_to :user
  validates :time, presence: true
  validates :genre, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
