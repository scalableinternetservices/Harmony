require "test_helper"

class MessageControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get message_create_url
    assert_response :success
  end

  test "should get post" do
    get message_post_url
    assert_response :success
  end
end
