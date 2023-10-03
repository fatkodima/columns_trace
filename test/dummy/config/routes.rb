# frozen_string_literal: true

Rails.application.routes.draw do
  (1..5).each do |i|
    get "/action#{i}", to: "users#action#{i}", as: "action#{i}"
  end
end
