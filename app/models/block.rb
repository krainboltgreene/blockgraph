class Block < ActiveRecord::Base
  belongs_to :account
  has_many :connections, dependent: :destroy

  default_scope  do
    order(:created_at)
  end

  attr_writer :username

  def trunk
    connections.trunk.profile
  end

  def leafs
    Profile.where(id: connections.leafs.pluck(:profile_id)).where.not(external_id: account.exemptions.pluck(:external_id))
  end

  def exemptions
    Profile.where(id: connections.leafs.pluck(:profile_id)).where(external_id: account.exemptions.pluck(:external_id))
  end
end
