require 'spec_helper'

class TestError < StandardError; end

describe Solution do
  let(:solution) { Solution.new }
  
  it "Won't create a solution if the upvote fails" do
    expect {
      Solution.any_instance.stub(update_user_solution_count: true)
      Solution.destroy_all
      solution.stub(run_problem: true)
      solution.stub(:user) { raise TestError}
      solution.problem_id = 1
      solution.user_id = 1

      solution.save!
    }.to raise_error(TestError)
    Solution.count.should be 0
  end
end