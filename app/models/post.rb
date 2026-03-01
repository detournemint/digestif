class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 500 }
  validate :one_post_per_day, on: :create

  before_create -> { self.published_at = Time.current }

  scope :from_yesterday, -> { where(published_at: Date.yesterday.all_day) }
  scope :recent, -> { order(published_at: :desc) }

  private

  def one_post_per_day
    if user&.posted_today?
      errors.add(:base, "You can only post once per day. Come back tomorrow!")
    end
  end
end
