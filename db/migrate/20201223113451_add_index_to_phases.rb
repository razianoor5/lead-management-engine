class AddIndexToPhases < ActiveRecord::Migration[5.2]
  def up
    add_index :phases, :is_complete
  end

  def down
    remove_index :phases, :is_complete
  end
end
