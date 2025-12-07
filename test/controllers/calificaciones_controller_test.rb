require "test_helper"

class CalificacionesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calificaciones_index_url
    assert_response :success
  end

  test "should get show" do
    get calificaciones_show_url
    assert_response :success
  end

  test "should get new" do
    get calificaciones_new_url
    assert_response :success
  end

  test "should get edit" do
    get calificaciones_edit_url
    assert_response :success
  end

  test "should get create" do
    get calificaciones_create_url
    assert_response :success
  end

  test "should get update" do
    get calificaciones_update_url
    assert_response :success
  end

  test "should get destroy" do
    get calificaciones_destroy_url
    assert_response :success
  end
end
