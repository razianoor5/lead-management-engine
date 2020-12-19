# frozen_string_literal: true

class AddIsCompleteToPhases < ActiveRecord::Migration[5.2]
  def change
    add_column :phases, :is_complete, :boolean, default: false
  end
end
