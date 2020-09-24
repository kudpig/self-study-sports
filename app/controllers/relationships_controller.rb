class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    # フォローを"受ける"ユーザーのidを取得し、@userに代入。
    # となると、viewの設定でfollowed_idをサーバーに送ってあげる処理が必要がありそう。
    current_user.follow(@user)
    # userモデルで設定したメソッドを実行している。
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    # モデルで設定している仕様では"配列形式に格納しているother_user"を取り除きたい.
    # なので削除しようとしているRelationshipレコードから"followedカラム"のユーザー情報を取得し@userに入れている。
    current_user.unfollow(@user)
    # userモデルで設定したメソッドを実行している。
  end
end
