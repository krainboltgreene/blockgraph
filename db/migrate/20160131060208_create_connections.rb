class CreateConnections < ActiveRecord::Migration
  def change
    create_table(:connections, id: :uuid) do |table|
      table.uuid :block_id, null: false, index: true
      table.uuid :profile_id, null: false, index: true
      table.uuid :trunk_id, index: true
      table.timestamps null: false, index: true

      table.index [:block_id, :profile_id], unique: true
    end
  end
end
