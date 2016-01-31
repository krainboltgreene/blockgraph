class RemoveNullConstraintOnUsernameFromProfiles < ActiveRecord::Migration
  def change
    change_column_null :profiles, :username, true
  end
end
