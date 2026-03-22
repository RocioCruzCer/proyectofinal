require "test_helper"

class PerfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get perfiles_index_url
    assert_response :success
  end
end
