require "test_helper"

class PermisosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get permisos_index_url
    assert_response :success
  end
end
