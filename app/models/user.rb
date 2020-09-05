class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  # userは複数のpostを持つというアソシエーション
  # userとpost両方ともアソシエーションを記入する必要がある

  has_many :comments, dependent: :destroy
  # userは複数のcommentを持つ
  # dependent: :destroyを設定することで、userを削除したときアソシエーション先（この場合はpost・comment）にもdestroyアクションを実行することができる（削除できる）

  has_many :likes, dependent: :destroy
  # ↓いいねをしたpostを取得するための記述
  has_many :like_posts, through: :likes, source: :post
  # throughオプションは指定したテーブルを経由して関連先のデータを取得できるようになるオプション。
  # "has_many :like_posts, through: :likes"のままではlikesテーブルを経由した後の参照先が不明。(like_postsはテーブル名ではなく独自に設定したメソッド名のようなもの?)
  # sourceオプションにより参照先のテーブルを明示することができる。
  # 'source: :post'としてあげれば、likesテーブルを経由しpostsテーブルのデータを取得してくることができる。

  # 〜〜なぜわざわざsourceオプションを使ってまでlike_postsという項目を作っているのか考察〜〜
  # 「userがいいねしたpostを取得したい」ということであれば、"has_many :posts, through: :likes"でも良いように一見考えられるが、
  # userとpostの間には既にアソシエーションが組まれており、そこに新たな関係性を追加することはできないためlike_postsという項目を設定する必要がある。

  def like(post)
    like_posts << post
    # current_userが持つ"like_posts"を配列形式とし、コントローラーより受け取った"postオブジェクト(いいねしようとしている投稿)"を
    # いいねするたびに格納していくという処理。
  end

  def unlike(post)
    like_posts.destroy(post)
    # current_userが持つ"like_posts"に格納されているpost(コントローラーから受け取ったpost)を削除する。
  end

  def like?(post)
    like_posts.include?(post)
    # current_userが持つ"like_posts"にコントローラーより受け取った"postオブジェクト"が格納されているかどうかを確認する。
    # 配列current_userが、postと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true
end
