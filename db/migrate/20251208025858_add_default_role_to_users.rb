class AddDefaultRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :role, from: nil, to: 'usuario'
    User.where(role: nil).update_all(role: 'usuario')
  end
end
