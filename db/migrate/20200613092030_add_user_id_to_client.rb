class AddUserIdToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :user_id, :bigint
  end
end
