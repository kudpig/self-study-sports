class PostsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  # require_loginメソッドにより、ログインしていないユーザは上記５つのアクションを実行できない

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page])
    # includesがないとuser_idについてsqlが多量発行される（N+1問題の解消）
    # orderはrailsのActiveRecordメソッドのひとつ。()内記述で並び順を変更できる。descは降順
    # .page(params[:page])により現在のページパラメーターを受け取っている
    # kaminariのデフォルト設定により最初のページはparamsを無視する（config.params_on_first_page = false）
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
    # 他人が編集ページに遷移できなくするためにcurrent_userをつけている。
    # 上記を設定しないと/posts/:id/editのid部分を変えたら入れてしまう。
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    # 投稿詳細ページでコメントを表示させるための記述。@postに紐づくコメントを@commentに入れる
    # 一覧ページと同じで、N+1対策と並び順
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      redirect_to posts_path, success: '投稿を削除しました'
    else
      # 万が一削除に失敗した場合はフラッシュを表示し、直前ページに戻る仕様にした。
      # （削除場所がindexページとshowページの2パターンあるため）
      flash.now[:danger] = '投稿の削除に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, images: []).merge(user_id: current_user.id)
    # images:[]とする事で、imagesを配列の形で扱うことができる
  end
end
