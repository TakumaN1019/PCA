class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :sender_id
      t.integer :sending_id

      t.timestamps null: false
    end

    add_index :relationships, :sender_id
    add_index :relationships, :sending_id
    add_index :relationships, [:sender_id, :sending_id], unique: true
  end
end
