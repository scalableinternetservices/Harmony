class AddReference2ActionNotification < ActiveRecord::Migration[6.1]
  def change
    drop_table :employees
  end
end
