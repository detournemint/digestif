class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :body, presence: true, length: { maximum: 500 }
  validate :one_post_per_day, on: :create
  validate :image_is_image, if: -> { image.attached? }

  before_create -> { self.published_at = Time.current }

  scope :from_yesterday, -> { where(published_at: Date.yesterday.all_day) }
  scope :recent, -> { order(published_at: :desc) }

  private

  def image_is_image
    unless image.blob.content_type.start_with?("image/")
      errors.add(:image, "must be an image file")
    end
    if image.blob.byte_size > 10.megabytes
      errors.add(:image, "must be smaller than 10MB")
    end
  end

  def one_post_per_day
    if user&.posted_today?
      errors.add(:base, "You can only post once per day. Come back tomorrow!")
    end
  end
end
