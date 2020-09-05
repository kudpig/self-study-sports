class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    # userモデルで設定したlikeメソッド。(モデルにpost_idを渡すために1行目で@postを取得している)
  end

  def destroy
    @post = Like.find(params[:id]).post
    # 外そうとしている"いいね"のIDを取得し、そのlike_idに紐づくpostをを@postに格納
    current_user.unlike(@post)
    # userモデルで設定したunlikeメソッドを実行している。
  end
end
