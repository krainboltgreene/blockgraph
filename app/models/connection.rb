class Connection < ActiveRecord::Base
  belongs_to :block
  belongs_to :profile
  belongs_to :trunk, class_name: "Profile", foreign_key: "trunk_id"

  scope :leafs, -> do
    joins(:profile).where.not(trunk_id: nil)
  end

  def self.trunk
    joins(:profile).where(trunk_id: nil).first
  end

  validates :block, presence: true
  validates :profile, presence: true
end
