class SolutionService
  def initialize(args={})
    @user = args.fetch(:user)
    @problem = args.fetch(:problem)
    @page = args.fetch(:page, 1)
  end

  def solutions
    if @problem.solved?(@user) || @user.admin
      [top, followed]
    else
      skip_problem
      [bottom, nil]
    end
  end

  private

  def skip_problem
    @user.skipped_problems[@problem.id] = true and @user.save
  end

  def bottom
    Solution.bottom_solutions(@problem, @page)
  end

  def top
    Solution.top_solutions(@problem, @user, @page)
  end

  def followed
    @user.users_followed.map {|u| u.solutions.where(problem_id: @problem.id).first}.compact
  end
end
