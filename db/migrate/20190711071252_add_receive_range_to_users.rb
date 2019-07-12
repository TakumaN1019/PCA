class AddReceiveRangeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :receive_range, :string, default: "all"
  end
end
