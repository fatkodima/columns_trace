# frozen_string_literal: true

class SidekiqJob
  include Sidekiq::Job

  def perform
    User.first.name
  end
end
