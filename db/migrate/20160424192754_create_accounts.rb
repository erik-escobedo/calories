class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :owner_id

      t.timestamps null: false
    end

    add_index :accounts, :owner_id, unique: true

    add_column :users, :account_id, :integer
    add_index :users, :account_id
  end
end
