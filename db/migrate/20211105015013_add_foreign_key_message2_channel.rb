class AddForeignKeyMessage2Channel < ActiveRecord::Migration[6.1]
  def change
    change_table :messages do |t|
      t.references :channel, index: true, foreign_key: true
    end
  end
end
