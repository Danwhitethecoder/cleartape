class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.timestamps
      t.string :name
      t.string :phone
      t.string :sex
      t.integer :age
    end
  end

  def down
    drop_table :users
  end
end
