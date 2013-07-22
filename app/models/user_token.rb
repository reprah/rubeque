class UserToken
  # holds the provider authentication for users
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Audit::Trackable
  field :provider, :type => String
  field :uid, :type => String

  belongs_to :user

  validates_uniqueness_of :uid, scope: :provider

  track_history :track_create   => true,
                :track_destroy  => true
end
