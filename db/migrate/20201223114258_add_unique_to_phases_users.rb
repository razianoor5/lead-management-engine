class AddUniqueToPhasesUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :phases_users, :user_id, :bigint, unique: :true
  end

  def down
    change_column :phases_users, :user_id, :bigint, unique: :false
  end
end
