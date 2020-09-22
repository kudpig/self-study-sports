class Mypage::BaseController < ApplicationController
  before_action :require_login
  layout 'mypage'
  # レイアウトファイル名を指定。これでlayouts/mypage.html.slimが適用される。
end
# 今後マイページに機能を追加していくと、mypageディレクトリのコントローラー数が増えていく。
# なのでApplicationControllerの機能をいったんbasecontrollerで受け取り、マイページ共通の処理はこちらに書いていくのが良い
