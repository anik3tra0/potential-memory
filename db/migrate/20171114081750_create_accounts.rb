class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :business_name
      t.string :subdomain

      t.timestamps null: false
    end
  end
end
