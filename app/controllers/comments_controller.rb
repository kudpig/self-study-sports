class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]
  # ログイン時のみ許可

  def create
    @comment = current_user.comments.create(comment_params)
    # current_userを指定してコメントのcreateを実行する
  end

  # editはshallowの対象
  def edit
    @comment = current_user.comments.find(params[:id])
  end

  # updateはshallowの対象
  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  # updateはshallowの対象
  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
    # post_idをcommentに紐づけて保存出来るようにする
    # user_idについてはcurrent_user.comments.create(comment_params)で取得できている
  end

  def comment_update_params
    params.require(:comment).permit(:body)
    # updateするものはbodyのみ。それ以外の項目が変更されることは基本的にないため許可する必要もない
  end
end
