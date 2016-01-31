class DeviseCreateAccounts < ActiveRecord::Migration
  def change
    create_table(:accounts, id: :uuid) do |table|
      table.string :username, null: false, index: true
      table.string :provider, null: false, index: true
      table.string :external_id, null: false, index: true
      table.string :access_public, null: false, index: true
      table.string :access_private, null: false, index: true
      table.timestamps null: false, index: true

      table.index [:username, :provider, :external_id, :access_public, :access_private], unique: true, name: "index_unique_credentials_on_accounts"
    end
  end
end
