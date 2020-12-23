class AddIndexToLeads < ActiveRecord::Migration[5.2]
  def up
    add_index :leads, :is_sale
  end

  def down
    remove_index :leads, :is_sale
  end
end
