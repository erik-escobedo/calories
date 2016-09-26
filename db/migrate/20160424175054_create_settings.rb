class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id
      t.integer :daily_calories, default: 2200
    end

    add_index :settings, :user_id, unique: true
  end
end
