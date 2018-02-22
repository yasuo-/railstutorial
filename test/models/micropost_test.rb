require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # このcodeは、慣習的に正しくない
    # @micropost = Micropost.new(content: 'Lorem ipsum', user_id: @user.id)
    # 修正版
    @micropost = @user.micropost.build(content: 'Lorem ipsum')
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 characters' do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
