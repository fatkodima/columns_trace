# frozen_string_literal: true

require "test_helper"

class MailerTest < ActionMailer::TestCase
  setup do
    @user = User.first
  end

  test "reports unused columns" do
    email = UserMailer.with(user: @user).unused_fields_email
    output = capture_logging do
      email.deliver_now
    end

    assert_match %(UserMailer#unused_fields_email\n  1 Project record: unused columns - "id"; used columns - "name"), output
    assert_match "↳", output
    assert_match(/app\/mailers\/user_mailer\.rb:\d+:in `unused_fields_email/, output)
  end

  test "does not report when all columns are used" do
    email = UserMailer.with(user: @user).used_fields_email
    output = capture_logging do
      email.deliver_now
    end

    assert_empty output
  end
end
