class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :status
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
