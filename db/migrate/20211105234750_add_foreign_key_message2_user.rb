class AddForeignKeyMessage2User < ActiveRecord::Migration[6.1]
  def change
    change_table :messages do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
