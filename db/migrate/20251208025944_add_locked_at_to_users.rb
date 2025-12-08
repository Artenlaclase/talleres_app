class AddLockedAtToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :locked_at, :datetime
  end
end
