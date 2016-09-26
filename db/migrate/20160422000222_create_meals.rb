class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :user_id
      t.integer :calories
      t.text :description
      t.datetime :taken_at

      t.timestamps null: false
    end

    add_index :meals, :user_id
    add_index :meals, :created_at
  end
end
