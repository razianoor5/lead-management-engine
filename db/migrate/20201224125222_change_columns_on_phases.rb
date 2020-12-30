class ChangeColumnsOnPhases < ActiveRecord::Migration[5.2]
  def up
    change_column :phases, :assignee, :string, null: false
    change_column :phases, :start_date, :datetime, null: false
    change_column :phases, :due_date, :datetime, null: false
  end

  def down
    change_column :phases, :assignee, :string, null: true
    change_column :phases, :start_date, :datetime, null: true
    change_column :phases, :due_date, :datetime, null: true
  end
end
