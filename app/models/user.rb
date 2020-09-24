class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  # userは複数のpostを持つというアソシエーション
  # userとpost両方ともアソシエーションを記入する必要がある

  has_many :comments, dependent: :destroy
  # userは複数のcommentを持つ
  # dependent: :destroyを設定することで、userを削除したときアソシエーション先（この場合はpost・comment）にもdestroyアクションを実行することができる（削除できる）

  # 【いいね機能に関するアソシエーション】
  has_many :likes, dependent: :destroy
  # ↓いいねをしたpostを取得するために記述。ActiveRecordの関連付け。correctionを取得する。
  has_many :like_posts, through: :likes, source: :post
  # throughオプションは指定したテーブルを経由して関連先のデータを取得できるようになるオプション。
  # "has_many :like_posts, through: :likes"のままではlikesテーブルを経由した後の参照先が不明。(like_postsはテーブル名ではなく独自に設定したメソッド名のようなもの?)
  # sourceオプションにより参照先のテーブルを明示することができる。
  # 'source: :post'としてあげれば、likesテーブルを経由しpostsテーブルのデータを取得してくることができる。

  # 〜〜なぜわざわざsourceオプションを使ってまでlike_postsという項目を作っているのか〜〜
  # 「userがいいねしたpostを取得したい」ということであれば、"has_many :posts, through: :likes"でも良いように一見考えられるが、
  # userとpostの間には既にアソシエーションが組まれており、そこに新たな関係性を追加することはできないためlike_postsという項目を設定する必要がある。

  # 【フォロー機能に関するアソシエーション】
  # userとrelationshipについてアソシエーションを組む必要がある。簡潔に"has_many :relationships"としたい所だが、
  # relationshipテーブルに２つあるカラムはどちらもuserテーブルに紐づく中間テーブルとなっており、どちらのカラムとのアソシエーションなのかをしっかり区別してあげる必要がある。
  # よって、以下２パターンのアソシエーションを記述するということになる。
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  # "User"とRelationshipテーブルの「follower_id」とのアソシエーションを設定している。
  # active_relationshipsと命名しているため、class_nameでテーブル名を明示。かつforeign_key設定により参照するカラムも指定。
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # 上と同じ。

  # ActiveRecordの関連付け。correctionを取得する。
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # "User"が「フォローをしている相手」および「フォローを受けている相手」を取得できるようにするための記述。
  # 上記で設定した"〜〜〜_relationships"を経由し、sourceを持つuserを関連付ける。
  # user.followingを実行する→→"active_relationships"を経由する(userは自身のidを元にRelationテーブル/follower_idを参照)→→sourceオプションにより、idが一致したレコードのデータを取得できる
  # 要は関連付けされたコレクションを取得できるよってこと。

  # 【いいね機能に関するメソッド】
  # 主にhas_many関連付けをしたコレクションメソッド"like_posts"を使用する。"self"は省略されている。
  def like(post)
    like_posts << post
    # current_userが持つ"like_posts"に、コントローラーより受け取った"postオブジェクト(いいねしようとしている投稿)"をいいねするたびに格納していくという処理。
    # <<はRubyのArrayクラスのインスタンスメソッド。pushでもいいかも。
    # あまりRubyっぽくないが次のように書き換えも可。
    # self.like_posts.push(post)※もしやこっちの方がわかりやすいのでは・・・
  end

  def unlike(post)
    like_posts.destroy(post)
    # current_userが持つ"like_posts"に格納されているpost(コントローラーから受け取ったpost)を削除する。
  end

  def like?(post)
    like_posts.include?(post)
    # current_userが持つ"like_posts"にview(_like_area)より受け取った"postオブジェクト"が格納されているかどうかを確認する。
    # like_postsが、postと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  # 【フォロー機能に関するメソッド】
  # 上記"いいね機能"とほぼ同じロジックを用いている。
  def follow(other_user)
    following << other_user
    # current_userが持つ"following"に、コントローラーより受け取った"other_userオブジェクト(@userのこと)"をフォローするたびに格納していくという処理。
    # <<はRubyのArrayクラスのインスタンスメソッド。
    # 書き換えも可。→ self.following.push(other_user)
  end

  def unfollow(other_user)
    following.destroy(other_user)
    # current_userが持つ"following"に格納されているother_user(コントローラーから受け取った@user)を削除する。
  end

  def following?(other_user)
    following.include?(other_user)
    # current_userが持つ"following"にview(_follow_area)より受け取った"userオブジェクト"が格納されているかどうかを確認する。
    # followingが、userと等しい要素を持つ時にtrue、持たない時にfalseを返す。
  end

  def feed
    Post.where(user_id: following_ids << id)
    # postの中から、post.user_idが条件に一致するものを探す。
    # whereは条件に合うレコードを全て返す処理を行う。
    # whereの中身はハッシュである。キー：user_id、値：following_ids << id
    # 値：following_ids << idは次のように書き換えできる。 self.following_ids.push(self.id)
    # following_idsは、ActiveRecordのcollection_singular_idsメソッド。Railsガイド4.3.1.7参照
    # 要するに、following_idsメソッドに自分のuser.idを加えたものを戻り値として返すということ。
  end

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  # 作成順での並び替え。(count)で数字を引数として受け取れる。

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true
end
