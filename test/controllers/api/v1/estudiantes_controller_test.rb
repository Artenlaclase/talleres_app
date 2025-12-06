require "test_helper"

class Api::V1::EstudiantesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_estudiantes_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_estudiantes_show_url
    assert_response :success
  end
end
