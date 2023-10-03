# frozen_string_literal: true

class UsedJob < ActiveJob::Base
  def perform
    User.first.inspect
  end
end
