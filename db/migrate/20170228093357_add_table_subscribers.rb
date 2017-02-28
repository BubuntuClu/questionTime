class AddTableSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.integer :user_id
      t.integer :question_id
      t.belongs_to :question, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
    add_index :subscribers, [:user_id, :question_id]
  end
end
