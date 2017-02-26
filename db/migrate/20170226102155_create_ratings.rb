class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.date :day
      t.references :user, foreign_key: true
    end
  end
end
