class ChangeContactTypeToString < ActiveRecord::Migration[5.2]
  def up
    change_column :leads, :client_contact, :string
  end

  def down
    change_column :leads, :client_contact, :integer
  end
end
