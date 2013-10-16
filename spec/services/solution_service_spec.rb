require 'spec_helper'

describe SolutionService do
  let(:user) { User.create(validate: false) }
  let(:problem) { Problem.create(validate: false) }

  before {
    5.times do |i|
      s = Solution.new
      s.problem_id = problem.id
      s.score = i
      s.save(validate: false)
    end
  }

  shared_examples 'solved problem' do
    it 'returns top solutions' do
      top, _ = SolutionService.new(user: user, problem: problem, page: 1).solutions
      top.first.score.should be > top.last.score
    end

    it 'returns followed solutions' do
      _, followed = SolutionService.new(user: user, problem: problem, page: 1).solutions
      followed.should_not be_nil
    end
  end

  describe '#solutions' do
    context 'when a user has solved a problem' do
      before { problem.stub(solved?: true) }
      it_behaves_like 'solved problem'
    end

    context 'when a user is an admin' do
      before { user.admin = true and user.save }
      it_behaves_like 'solved problem'
    end

    context 'when a user has not solved a problem' do
      it 'returns the bottom few solutions' do
        bottom, _ = SolutionService.new(user: user, problem: problem, page: 1).solutions
        bottom.count(true).should eq 3 # pass true to #count for it to obey limit statements
        bottom.first.score.should < bottom.last.score
      end

      it 'marks the problem as skipped' do
        SolutionService.new(user: user, problem: problem, page: 1).solutions
        user.skipped_problems[problem.id].should eq true
      end
    end
  end
end
