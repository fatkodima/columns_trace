# frozen_string_literal: true

class UnusedJob < ActiveJob::Base
  def perform
    User.first.email
  end
end
