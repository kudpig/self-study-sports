class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 255 }
  # bodyはnullを許可していない。文字数にも制約をつけた。
end
