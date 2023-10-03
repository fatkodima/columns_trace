# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.timestamps
  end

  create_table :projects, force: true do |t|
    t.string :name
  end
end
