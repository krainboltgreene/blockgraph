class ChangeConnectionsUniqueIndexOnConnections < ActiveRecord::Migration
  def change
    remove_index :connections, [:block_id, :profile_id]
    add_index :connections, [:block_id, :profile_id, :trunk_id], unique: true
  end
end
