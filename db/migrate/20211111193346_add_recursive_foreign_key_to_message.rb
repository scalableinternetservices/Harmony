class AddRecursiveForeignKeyToMessage < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.references :parent_message, foreign_key: { to_table: :employees }
      t.timestamps
    end
  end
end
