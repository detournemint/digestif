class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  normalizes :username, with: ->(u) { u.strip }

  def following?(user)
    following.include?(user)
  end

  def follow(user)
    following << user unless self == user || following?(user)
  end

  def unfollow(user)
    following.delete(user)
  end

  def posted_today?
    posts.where(published_at: Date.current.all_day).exists?
  end

  def todays_post
    posts.find_by(published_at: Date.current.all_day)
  end
end
