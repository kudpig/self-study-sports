class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  # uploaderファイルをimagesカラムに適用
  # 複数画像を取り扱うのでuploadersと複数形にする

  serialize :images, JSON
  # carrierwaveで複数画像を保存する場合はJSON型で扱う必要がある。
  # DBをJSON型で設定していないケースでは、modelにて設定する。

  belongs_to :user
  # postは１つのuserを持つ、というアソシエーション
  # この記載がないと、参照先(この場合はuser)テーブルにアクセスできない

  has_many :comments, dependent: :destroy
  # postは複数のcommentを持つ
  # dependent: :destroyについてはuserモデルに記述済

  validates :body, presence: true, length: { maximum: 255 }
  validates :images, presence: true
  # migrationファイルでnullfalseをつけたものはこちらでもバリデーションをつける。
end
