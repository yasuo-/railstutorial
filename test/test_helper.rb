require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# 統合テストで扱うヘルパー
# ただし統合テストではsessionを直接取り扱うことができないので、
# 代わりにSessionsリソースに対してpostを送信することで代用
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  # use: log_in_as(@user, remember_me: '1') -> ON
  #      log_in_as(@user, remember_me: '0') -> OFF
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
