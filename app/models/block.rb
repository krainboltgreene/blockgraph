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
    connections.leafs.map(&:profile)
  end
end
