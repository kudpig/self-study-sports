class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  # uploaderファイルをimageカラムに適用
  # 今後複数画像を取り扱うことになった場合はuploaders:imagesと複数形にする

  # serialize :images, JSON
  # carrierwaveで複数画像を保存する場合はJSON型で扱う必要がある。
  # DBをJSON型で設定していないケースでは、modelにて設定する。

  belongs_to :user
  # postは１つのuserを持つ、というアソシエーション
  # この記載がないと、参照先(この場合はuser)テーブルにアクセスできない

  has_many :comments, dependent: :destroy
  # postは複数のcommentを持つ
  # dependent: :destroyについてはuserモデルに記述済

  has_many :likes, dependent: :destroy
  # ↓いいねをしたuserを取得するための記述
  has_many :like_users, through: :likes, source: :user
  # 内容についてはuser.rbと重複するので割愛

  scope :body_contain, ->(word) { where('body LIKE ?', "%#{word}%") }
  # 検索のロジックを記述。検索フォームに入力されたものを第2引数である、"->(word) { where('body LIKE ?', "%#{word}%") }" を実行し、値を返す。
  # （SearchPostsFormインスタンスのself.bodyを受け取っている）
  # プレースホルダーを用い、SQLインジェクションを回避。

  validates :body, presence: true, length: { maximum: 255 }
  validates :image, presence: true
  # migrationファイルでnullfalseをつけたものはこちらでもバリデーションをつける。
end
