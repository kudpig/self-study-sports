class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 一つのいいねには、必ず一人のユーザーと一つの投稿が紐づく

  validates :user_id, uniqueness: { scope: :post_id }
  # この記述でpost_idとuser_idの組をuniqueにした。１通りのみ許可のバリデーション。
  # uniquenessはRails Validationヘルパーの一つ。
  # 属性の値が一意（unique）であり重複していないことを検証する。
  # 属性について同じ値のレコードがモデルにあるかをクエリを走らせ確認する。
  # scopeオプションは他のカラムに一意性制約を求めることが出来る。
  # 今回のケースだと、ひとつの":user_id"シンボルに紐づくscope先の"post_id"カラムのレコードに対しuniquenessを実行している。
end
