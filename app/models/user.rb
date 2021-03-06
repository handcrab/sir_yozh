class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :channels, dependent: :destroy
  has_many :posts, through: :channels

  after_create :make_token

  private

  def make_token
    salt =  Rails.application.class.parent_name
    update token: Digest::SHA1.hexdigest(email + created_at.to_s + salt)
  end
end
