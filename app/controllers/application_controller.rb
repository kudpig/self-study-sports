class ApplicationController < ActionController::Base
  before_action :set_search_posts_form
  add_flash_types :success, :info, :warning, :danger

  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
    # not_authenticatedはsorceryにデフォルトで設定されているメソッド。require_loginに引っかかった時に実行される。
    # ログインしていない状態のときにURL直打ちで直接アクセスしようとした場合は警告を出しログインページへ。
  end

  private

  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
    # SearchPostsFormクラスのインスタンスを作る。
    # ヘッダーに検索フォームを入れてるので、こちらへの記載となる。
    # 全てのページに存在するので、その都度インスタンスが作られることになる。
  end

  def search_post_params
    params.fetch(:q, {}).permit(:body)
    # fetchメソッドにより、キー"q"について{" "}がデフォルト値として扱われるようになる。
    # "q"はqueryの略。GETリクエストのパラメータをクエリと呼ぶのが一般的。
  end
end
