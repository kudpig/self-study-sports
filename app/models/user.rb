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



  # 【フォロー機能に関するアソシエーション】
  # userとrelationshipについてアソシエーションを組む必要がある。簡潔に"has_many :relationships"としたい所だが、
  # relationshipテーブルに２つあるカラムはどちらもuserテーブルに紐づく中間テーブルとなっており、どちらのカラムとのアソシエーションなのかをしっかり区別してあげる必要がある。
  # よって、以下２パターンのアソシエーションを記述するということになる。
  # ↓①
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # "User"とRelationshipテーブルの「follower_id」とのアソシエーションを設定している。
  # active_relationshipsとしているため、class_nameでテーブル名を明示。かつforeign_key設定により参照するカラムも指定。
  has_many :following, through: :active_relationships, source: :followed
  # "User"が「フォローをしている相手」を取得できるようにするための記述。
  # 上記で設定した"active_relationships"を経由し、"followed_id"を持つuserを関連付ける。
  # user.followingを実行する→→"active_relationships"を経由する(userは自身のidを元にRelationテーブル/follower_idを参照)→→sourceオプションにより、idが一致したレコードの"followed_id"データを取得できる
  # ↓②
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  # "User"が「フォローを受けている相手」を取得できるようにするための記述。
  # 上記と考え方は同じ。違うのは、Userの"user_id"をRelationshipテーブルのどのカラムで探しているかということ。
  # 今回は、user.followersを実行する→→"passive_relationships"を経由する(userは自身のidを元にRelationテーブル/followed_idを参照)→→sourceオプションにより、idが一致したレコードの"follower_id"データを取得できる

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
    # current_userが持つ"like_posts"にview(_like_area)より受け取った"postオブジェクト"が格納されているかどうかを確認する。
    # 配列like_postsが、postと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true
end
