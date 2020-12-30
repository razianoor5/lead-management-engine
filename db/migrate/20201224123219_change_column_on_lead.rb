class ChangeColumnOnLead < ActiveRecord::Migration[5.2]
  def up
    change_column :leads, :client_contact, :string, null: false
    change_column :leads, :client_name, :string, null: false
    change_column :leads, :client_email, :string, null: false
  end

  def down
    change_column :leads, :client_contact, :string, null: true
    change_column :leads, :client_name, :string, null: true
    change_column :leads, :client_email, :string, null: true
  end
end
