class Profile < ActiveRecord::Base
  has_many :connections, dependent: :destroy

  validates :username, presence: true
  validates :external_id, presence: true
  validates :provider, presence: true
end
