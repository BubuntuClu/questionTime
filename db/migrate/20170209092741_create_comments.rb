class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|

      t.timestamps
    end
    add_column :comments, :body, :string
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    add_index :comments, [:commentable_id, :commentable_type]
    add_reference :comments, :users, foreign_key: true, index: true
  end
end
