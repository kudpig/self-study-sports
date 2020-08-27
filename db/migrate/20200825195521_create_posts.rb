class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :images, null: false
      # 画像は複数登録なのでimagesにしている。
      t.text :body, null: false
      t.references :user, foreign_key: true
      # foreign_keyはどのカラムにキー制約をつけるのか、という設定をすることが出来る。
      # 今回だと、t.references :userすなわちuser_idについて外部キー指定する。
      # 該当カラムには自由に値を入れることは出来ず、ユーザーテーブルに存在しているレコードのidしか設定できないという「制約」が与えられる。

      t.timestamps
    end
  end
end
