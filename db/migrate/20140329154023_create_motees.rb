class CreateMotees < ActiveRecord::Migration
  def change
    create_table :motees do |t|
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end
end
