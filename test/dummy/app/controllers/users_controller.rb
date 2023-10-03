# frozen_string_literal: true

class UsersController < ActionController::Base
  # Multiple records with unused columns.
  def action1
    user1, user2 = User.all.to_a
    user1.email
    user2.name
    head :ok
  end

  # Single record with unused columns.
  def action2
    user = User.first
    user.id
    head :ok
  end

  # Single record with all used columns.
  def action3
    user = User.first
    user.inspect
    head :ok
  end

  # Different backtraces.
  def action4
    User.first
    User.last
    head :ok
  end

  # Different models.
  def action5
    User.first
    Project.last
    head :ok
  end
end
