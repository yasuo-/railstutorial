class Micropost < ApplicationRecord
  # マイクロポストがユーザーに所属する (belongs_to) 関連付け
  belongs_to :user
  # default_scopeでマイクロポストを順序付ける
  # order(:created_at)だとデフォルトの順序が昇順 (ascending) となっている
  # 古いものから順に並ぶ
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
