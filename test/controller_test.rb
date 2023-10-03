# frozen_string_literal: true

require "test_helper"

class ControllerTest < ActionDispatch::IntegrationTest
  test "GET /action1" do
    output = capture_logging do
      get action1_path
    end

    assert_match %(UsersController#action1\n  2 User records: unused columns - "id", "created_at", "updated_at"; used columns - "email", "name"), output
    assert_match "↳", output
    assert_match(/app\/controllers\/users_controller\.rb:\d+:in `action1/, output)
  end

  test "GET /action2" do
    output = capture_logging do
      get action2_path
    end

    assert_match %(UsersController#action2\n  1 User record: unused columns - "name", "email", "created_at", "updated_at"; used columns - "id"), output
    assert_match "↳", output
    assert_match(/app\/controllers\/users_controller\.rb:\d+:in `action2/, output)
  end

  test "GET /action3" do
    output = capture_logging do
      get action3_path
    end

    assert_empty output
  end

  test "GET /action4" do
    output = capture_logging do
      get action4_path
    end

    assert_equal 2, output.count("↳")
  end

  test "GET /action5" do
    output = capture_logging do
      get action5_path
    end

    assert_match %(UsersController#action5\n  1 User record: unused columns - "id", "name", "email", "created_at", "updated_at"; used columns -), output
    assert_match '  1 Project record: unused columns - "id", "name"; used columns -', output
  end

  test "ignored models" do
    ColumnsTrace.ignored_models = [User]

    output = capture_logging do
      get action1_path
    end

    assert_empty output
  ensure
    ColumnsTrace.ignored_models = []
  end

  test "ignored columns" do
    ColumnsTrace.ignored_columns = [:created_at, { Project => :name }]

    output = capture_logging do
      get action5_path
    end

    assert_match %(UsersController#action5\n  1 User record: unused columns - "id", "name", "email", "updated_at"; used columns -), output
    assert_match '  1 Project record: unused columns - "id"; used columns -', output
  ensure
    ColumnsTrace.ignored_columns = []
  end
end
