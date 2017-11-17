class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.integer :account_id
      t.string :token

      t.timestamps null: false
    end
  end
end
