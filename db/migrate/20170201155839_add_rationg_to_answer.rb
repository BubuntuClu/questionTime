class AddRationgToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :rating, :integer, default: 0
  end
end
