class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  # userは複数のpostを持つというアソシエーション
  # userとpost両方ともアソシエーションを記入する必要がある

  # dependent: :destroyを設定することで、userを削除したときアソシエーション先（この場合はposts）にもdestroyアクションを実行することができる（削除できる）

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true
end
