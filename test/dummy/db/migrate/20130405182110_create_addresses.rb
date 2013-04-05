class CreateAddresses < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.timestamps
      t.references    :user,            :null => false
      t.string        :name,            :null => false
      t.string        :street_address,  :null => false
      t.string        :city,            :null => false
      t.string        :postcode,        :null => false
      t.string        :country,         :null => false, :length => 2
    end
    add_index :addresses, :user_id
  end

  def down
    drop_table :addresses
  end
end
