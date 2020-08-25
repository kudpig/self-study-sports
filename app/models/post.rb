class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  # uploaderファイルをimagesカラムに適用
  # 複数画像を取り扱うのでuploadersと複数形にする

  belongs_to :user
  # postは１つのuserを持つ、というアソシエーション
  # この記載がないと、参照先(この場合はuser)テーブルにアクセスできない

  validates :body, presence: true, length: { maximum: 255 }
  validates :images, presence: true
  # migrationファイルでnullfalseをつけたものはこちらでもバリデーションをつける。
end
