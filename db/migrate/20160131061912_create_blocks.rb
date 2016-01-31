class CreateBlocks < ActiveRecord::Migration
  def change
    create_table(:blocks, id: :uuid) do |table|
      table.uuid :account_id, null: false, index: true
      table.timestamps null: false, index: true
    end
  end
end
