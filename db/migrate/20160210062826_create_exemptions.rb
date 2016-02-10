class CreateExemptions < ActiveRecord::Migration
  def change
    create_table :exemptions, id: :uuid do |table|
      table.text :external_id
      table.uuid :account_id, null: false, index: true
      table.timestamps null: false, index: true

      table.index [:external_id, :account_id]
    end
  end
end
