# frozen_string_literal: true

class ChangeIsSaleTypeToBooleanInLeads < ActiveRecord::Migration[5.2]
  def up
    remove_column :leads, :is_sale, :string
    add_column :leads, :is_sale, :boolean, default: false
  end

  def down
    remove_column :leads, :is_sale, :boolean, default: false
    add_column :leads, :is_sale, :string
  end
end
