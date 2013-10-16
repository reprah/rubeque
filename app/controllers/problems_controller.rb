class ProblemsController < ApplicationController
  before_filter :restrict_to_admin, only: [:edit,:update,:destroy,:unapproved]
  before_filter :authenticate_user!, only: [:new]
  
  def index
    @problems = Problem.approved.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problems }
    end
  end

  def unapproved
    @problems = Problem.unapproved.asc(:created_at).page(params[:page] || 1)
    respond_to do |format|
      format.html { render 'index.html.erb' }
      format.json { render json: @problems }
    end
  end

  def show
    @problem = Problem.find(params[:id]) rescue nil
    if @problem.nil? || (!@problem.approved? && !current_user_admin?)
      flash[:error] = "Problem not found"
      redirect_to root_path and return
    end

    @solved = @problem.solved?(current_user) if current_user

    @solution = if current_user && (solution =  @problem.solutions.where(user_id: current_user.id).first)
      solution
    else
      Solution.new(problem: @problem, code: params[:solution_code])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problem }
    end
  end

  def new
    @problem = Problem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problem }
    end
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def create
    @problem = Problem.new(params[:problem])
    @problem.creator = current_user

    respond_to do |format|
      if @problem.save
        ProblemMailer.new_problem_email(@problem).deliver unless current_user.admin?
        format.html { redirect_to problems_path, notice: 'Problem was successfully submitted.' }
        format.json { render json: @problem, status: :created, location: @problem }
      else
        format.html { render action: "new" }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def approve
    @problem = Problem.find(params[:id])
    @problem.approved = true
    respond_to do |format|
      if @problem.save
        Twitter.update("Rubeque has a new problem to solve: #{request.protocol}#{request.host}#{problem_path(@problem.id)}")
        format.html { redirect_to({action: 'unapproved'}, {notice: 'Problem was successfully approved.'}) }
        format.json { head :ok }
      else
        format.html { redirect_to @problem, notice: 'Approval failed!' }
      end
    end
  end

  def update
    @problem = Problem.find(params[:id])

    respond_to do |format|
      if @problem.update_attributes(params[:problem])
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @problem = Problem.find(params[:id])
    @problem.destroy

    respond_to do |format|
      format.html { redirect_to problems_url }
      format.json { head :ok }
    end
  end

  def rss
    @problems = Problem.approved.desc(:created_at)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  private
    def sort_column
      Problem.fields.keys.include?(params[:sort]) ? params[:sort] : :difficulty
    end
    
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : :asc
    end
end
