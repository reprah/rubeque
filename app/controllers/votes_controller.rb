class VotesController < ApplicationController
  respond_to :html, :json

  def create
    @vote, success = Voter.new(current_user: current_user, vote_params: params[:vote]).vote!
    if success
      render "show", layout: false
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end
end
