class Voter
  attr_reader :current_user, :params
  def initialize(args)
    @current_user = args.fetch(:current_user)
    @params = args.fetch(:vote_params)
  end
  
  def vote!
    if previous_vote && vote_toggled?
      toggle_vote
    elsif previous_vote
      change_vote
    else
      create_vote
    end
  end
  
  def previous_vote
    @vote ||= Vote.where(solution_id: params[:solution_id], user_id: current_user.id).first 
  end
  
  def toggle_vote
    destroyed = previous_vote.destroy
    update_scores if destroyed
    [previous_vote, destroyed]
  end
  
  def change_vote 
    previous_vote.up = params[:up]
    changed = previous_vote.save
    update_scores if changed
    [previous_vote, changed]
  end
  
  def create_vote
    vote ||= Vote.new(params)
    vote.user_id = current_user.id
    created = vote.save
    update_scores if created
    [vote, created]
  end
  
  def update_scores(vote = previous_vote)
    vote.update_user_score
    vote.update_solution_score
  end
  
  def vote_toggled?
    previous_vote.up.to_s == params[:up]
  end

end
