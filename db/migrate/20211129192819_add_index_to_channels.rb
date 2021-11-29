class AddIndexToChannels < ActiveRecord::Migration[6.1]
  def change
    add_index :channels, :name
  end
end
