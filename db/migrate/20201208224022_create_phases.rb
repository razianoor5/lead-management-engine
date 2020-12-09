# frozen_string_literal: true

class CreatePhases < ActiveRecord::Migration[5.2]
  def change
    create_table :phases do |t|
      t.string :phase_type
      t.string :assignee
      t.datetime :start_date
      t.datetime :due_date
      t.references :lead, foreign_key: true

      t.timestamps
    end
  end
end
