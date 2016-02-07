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
  after_create :ensure_existance

  private

  def request_information
    FetchTwitterUserWorker.perform_async(id)
  end

  def request_information
    CheckTwitterUserWorker.perform_async(id)
  end
end
