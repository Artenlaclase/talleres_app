require "test_helper"

class TalleresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get talleres_index_url
    assert_response :success
  end

  test "should get show" do
    get talleres_show_url
    assert_response :success
  end

  test "should get new" do
    get talleres_new_url
    assert_response :success
  end

  test "should get create" do
    get talleres_create_url
    assert_response :success
  end

  test "should get edit" do
    get talleres_edit_url
    assert_response :success
  end

  test "should get update" do
    get talleres_update_url
    assert_response :success
  end

  test "should get destroy" do
    get talleres_destroy_url
    assert_response :success
  end
end
