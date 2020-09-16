Rails.application.routes.draw do
  root to: 'posts#index'

  resources :users, only: %i[index new create show]
  resources :posts do
    collection do
      get 'search'
      # ネストすることでpostsコントローラーのsearchアクションを取得する。
      # collectionによりposts全体を対象としているため、idを必要としないパスとなる。
    end
    resources :comments, shallow: true
  end
  # shallowオプションについてはRailsガイド'ルーティング'の2.7.2を参考に記述
  # comment_idをparamsに持つアクション(show/edit/update/destroy)についてURLを短くすることができる。
  # (urlを短くしても一意性を確保出来ている)

  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
