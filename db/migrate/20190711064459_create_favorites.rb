class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :liker_id
      t.integer :liking_id

      t.timestamps null: false
    end

    add_index :favorites, :liker_id
    add_index :favorites, :liking_id
    add_index :favorites, [:liker_id, :liking_id], unique: true
  end
end
