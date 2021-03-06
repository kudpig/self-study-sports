# 検索のための新たなクラスを作成
class SearchPostsForm
  include ActiveModel::Model
  # DBを介さずActiveRecordを利用している時のような機能を得る
  # DBに保存せずにform_withで処理を返すことができるようになる
  include ActiveModel::Attributes
  # 属性を指定の型へ変換してくれる

  attribute :body, :string
  # 型の指定をしている。
  # キーがbodyのものはstring型となる。

  # posts_controllerのsearchアクションで実行される。
  # (application_controllerで定義した@search_formに対して)
  def search
    scope = Post.distinct
    if body.present?
      scope.body_contain(body)
      # 検索ロジックを実行。post.rbに記述。
    else
      scope
      # "if body.present?"がfalseだった場合にscopeを返す
      # つまり検索が空の場合はPost.distinctの結果のみ返すということ。
    end
  end
end
