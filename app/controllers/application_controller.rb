class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
    # not_authenticatedはsorceryにデフォルトで設定されているメソッド。require_loginに引っかかった時に実行される。
    # ログインしていない状態のときにURL直打ちで直接アクセスしようとした場合は警告を出しログインページへ。
  end
end
