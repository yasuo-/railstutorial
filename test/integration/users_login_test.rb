require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  # user flow
  # 1. ログイン用のパスを開く
  # 2. 新しいセッションのフォームが正しく表示されたことを確認する
  # 3. わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
  # 4. 新しいセッションのフォームが再度表示され、フラッシュメッセージが追加されることを確認する
  # 5. 別のページ (Homeページなど) にいったん移動する
  # 6. 移動先のページでフラッシュメッセージが表示されていないことを確認する
  #
  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # user flow
  # 1. ログイン用のパスを開く
  # 2. セッション用パスに有効な情報をpostする
  # 3. ログイン用リンクが表示されなくなったことを確認する
  # 4. ログアウト用リンクが表示されていることを確認する
  # 5. プロフィール用リンクが表示されていることを確認する
  # 注意) 複数のブラウザでのWindowでlogoutをクリックするユーザーをシュミレーションする
  #
  test 'login with valid information followed by logout' do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のWindowでlogoutをクリックするユーザーをシュミレーションする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
