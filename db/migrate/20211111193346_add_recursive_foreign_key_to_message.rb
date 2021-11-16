class AddRecursiveForeignKeyToMessage < ActiveRecord::Migration[6.1]
  def change
    change_table :messages do |t|
      t.references :parent_message, foreign_key: { to_table: :messages }
    end
  end
end
