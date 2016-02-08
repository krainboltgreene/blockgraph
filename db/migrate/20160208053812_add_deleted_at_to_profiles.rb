class AddDeletedAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :deleted_at, :datetime, index: true
  end
end
