module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのSessionを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーを返す(いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue, その他ならfalseをreturnする
  def logged_in?
    !current_user.nil?
  end

  # 永続Sessionの破棄
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
    # if request.get? -> getのみにしておく
    # GETリクエストが送られたときだけ格納
    # 例えばログインしていないユーザーがフォームを使って送信した場合、転送先のURLを保存させないようにできます。
    # 例えばユーザがセッション用のcookieを手動で削除してフォームから送信するケースなどです。
    # こういったケースに対処しておかないと、POSTや PATCH、DELETEリクエストを期待しているURLに対して、
    # (リダイレクトを通して) GETリクエストが送られてしまい、場合によってはエラーが発生します。
  end
end
