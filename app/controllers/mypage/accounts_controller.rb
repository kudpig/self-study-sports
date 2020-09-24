class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
    # ログイン中のユーザーを@userとする
  end

  def update
    @user = User.find(current_user.id)
    # ログイン中のユーザーを@userとする
    if @user.update(account_params)
      # @userをaccount_paramsの内容で上書きする
      redirect_to user_path(current_user), success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  def account_params
    params.require(:user).permit(:username, :avatar, :avatar_cache)
    # 現段階では、usernameとavatarのみ編集できるような作りになっている。
    # avatar_cacheは、carrerwaveの機能でアップロードしたファイルを一時保存してくれる機能。
    # バリデーションエラーなどでファイル消失したときに、ここから取り出せる。
  end
end
