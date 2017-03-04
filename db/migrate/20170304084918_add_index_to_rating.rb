class AddIndexToRating < ActiveRecord::Migration[5.0]
  def change
    add_index :ratings, [:user_id, :day], unique: true
  end
end
