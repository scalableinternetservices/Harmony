class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :firstname
      t.string :lastname
      t.integer :age
      t.string :gender
      t.string :location
      
      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
