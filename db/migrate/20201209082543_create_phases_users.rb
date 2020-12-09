# frozen_string_literal: true

class CreatePhasesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :phases_users, id: false do |t|
      t.references :user, foreign_key: true
      t.references :phase, foreign_key: true
    end
  end
end
