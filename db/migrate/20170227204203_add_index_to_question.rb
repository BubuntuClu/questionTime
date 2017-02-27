class AddIndexToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_index :questions, :created_at
  end
end
