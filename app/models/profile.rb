class Profile < ActiveRecord::Base
  acts_as_paranoid without_default_scope: true

  has_many :connections, dependent: :destroy

  validates :external_id, presence: true
  validates :provider, presence: true

  default_scope  do
    order(:created_at)
  end

  scope :twitter, -> do
    where(provider: "twitter")
  end
end
