class AddColumnSubscribeToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :subscribers, :integer, array: true, default: []
    add_index :questions, [:subscribers], using: :gin
    add_index :questions, [:id, :subscribers]
  end
end
