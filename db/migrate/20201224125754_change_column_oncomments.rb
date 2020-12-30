class ChangeColumnOncomments < ActiveRecord::Migration[5.2]
  def up
    change_column :comments, :body, :text, null: :false
    change_column :comments, :commentable_type, :string, null: :false
    change_column :comments, :commentable_id, :bigint, null: :false
  end

  def down
    change_column :comments, :body, :text, null: :true
    change_column :comments, :commentable_type, :string, null: :true
    change_column :comments, :commentable_id, :bigint, null: :true
  end
end
