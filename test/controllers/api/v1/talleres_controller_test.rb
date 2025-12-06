require "test_helper"

class Api::V1::TalleresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_talleres_index_url
    assert_response :success
  end
end
