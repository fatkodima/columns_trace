# frozen_string_literal: true

require "test_helper"

class JobTest < ActiveJob::TestCase
  test "reports unused columns" do
    output = capture_logging do
      UnusedJob.perform_now
    end

    assert_match %(UnusedJob#perform\n  1 User record: unused columns - "id", "name", "created_at", "updated_at"; used columns - "email"), output
    assert_match "↳", output
    assert_match(/app\/jobs\/unused_job\.rb:\d+:in `perform/, output)
  end

  test "does not report when all columns are used" do
    output = capture_logging do
      UsedJob.perform_now
    end

    assert_empty output
  end
end
