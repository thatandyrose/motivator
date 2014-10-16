class AddLastSentColumnToMotees < ActiveRecord::Migration
  def change
    add_column :motees, :last_sent_at, :datetime
  end
end
