# frozen_string_literal: true

class CreateLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :leads do |t|
      t.string :project_name
      t.string :client_name
      t.string :client_address
      t.string :client_email
      t.integer :client_contact
      t.string :platform_used
      t.string :is_sale
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
