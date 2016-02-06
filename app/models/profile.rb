class Profile < ActiveRecord::Base
  has_many :connections, dependent: :destroy

  validates :external_id, presence: true
  validates :provider, presence: true

  default_scope  do
    order(:created_at)
  end

  after_create :request_information

  scope :twitter, -> do
    where(provider: "twitter")
  end

  private

  def request_information
    FetchTwitterUserWorker.perform_async(id)
  end
end
