class Following
  include Mongoid::Document

  belongs_to :user
  belongs_to :follower, class_name: "User"

  index({follower_id: 1, user_id: 1}, { sparse: true })
end
