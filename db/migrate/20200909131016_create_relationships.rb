class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
      t.index [:follower_id, :followed_id], unique: true
      # follower_idとfollowed_idの組み合わせにユニーク制約をする。
    end
  end
end
