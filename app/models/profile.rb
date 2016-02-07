class Profile < ActiveRecord::Base
  has_many :connections, dependent: :destroy

  validates :external_id, presence: true
  validates :provider, presence: true

  default_scope  do
    order(:created_at)
  end

  scope :twitter, -> do
    where(provider: "twitter")
  end

  after_create :request_information

  private

  def request_information
    FetchTwitterUserWorker.perform_async(id)
  end
end
