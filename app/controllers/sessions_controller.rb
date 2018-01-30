class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクト
      login_in user
      redirect_to user
    else
      # create error message
      flash.now[:danger] = 'Invalid email or password combination'
      render 'new'
    end
  end

  def destory
  end

end
