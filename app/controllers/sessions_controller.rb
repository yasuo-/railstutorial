class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクト
      log_in(user)
      #  [remember me] チェックボックスの送信結果を処理する
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      # create error message
      flash.now[:danger] = 'Invalid email or password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
