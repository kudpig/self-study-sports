class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts
  # userは複数のpostを持つというアソシエーション
  # userとpost両方ともアソシエーションを記入する必要がある

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true
end
