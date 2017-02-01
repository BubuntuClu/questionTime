class AddColumnToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :value, :integer
    add_reference :votes, :users, foreign_key: true, index: true
  end
end
