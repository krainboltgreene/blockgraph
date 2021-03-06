class Account < ActiveRecord::Base
  devise :registerable
  devise :omniauthable, omniauth_providers: [:twitter]

  has_many :blocks, dependent: :destroy
  has_many :exemptions, dependent: :destroy

  default_scope  do
    order(:created_at)
  end

  validates :username, presence: true
  validates :external_id, presence: true
  validates :provider, presence: true
  validates :access_public, presence: true
  validates :access_private, presence: true

  def self.where_twitter(data)
    where(
      provider: data.provider,
      external_id: data.uid,
      username: data.info.nickname,
      access_public: data.credentials.token,
      access_private: data.credentials.secret
    )
  end
end
