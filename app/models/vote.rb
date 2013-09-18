class Vote
  include Mongoid::Document
  field :up, :type => Boolean
  belongs_to :user
  belongs_to :solution

  index({solution_id: 1, user_id: 1}, {sparse: true})

  validates_presence_of :user_id, :solution_id
  validates_uniqueness_of :user_id, scope: :solution_id

  scope :upvote, where(up: true)
  scope :downvote, where(up: false)

  def integer_value
    self.up? ? 1 : -1
  end

  def update_user_score
    solution.user.update_score
  end

  def update_solution_score
    solution.update_score
  end
end
