require "test_helper"

class ModulosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get modulos_index_url
    assert_response :success
  end
end
