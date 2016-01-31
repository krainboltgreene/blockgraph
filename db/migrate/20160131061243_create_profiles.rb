class CreateProfiles < ActiveRecord::Migration
  def change
    create_table(:profiles, id: :uuid) do |table|
      table.string :provider, null: false, index: true
      table.string :external_id, null: false, index: true
      table.string :username, null: false, index: true
      table.timestamps null: false, index: true
    end
  end
end
