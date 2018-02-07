require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # indexアクションのリダイレクトをテストする
  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should get new' do
    get signup_path
    assert_response :success
    assert_select 'title', "Sign up | #{@base_title}"
  end

  #  editアクションの保護に対するテストする
  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  #  updateアクションの保護に対するテストする
  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 間違ったユーザーが編集しようとしたときのテスト(edit)
  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 間違ったユーザーが編集しようとしたときのテスト(update)
  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert flash.empty?
    assert_redirected_to root_url
  end

end
