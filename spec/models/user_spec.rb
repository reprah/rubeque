require 'spec_helper'

describe User do
  let(:user) { User.new }

  describe '#failed_attempts' do
    it 'should return 0 if failed_attempts is nil' do
      user['failed_attempts'].should be_nil
      user.failed_attempts.should == 0
    end
  end

  describe '#sum_difficulty_points' do
    it 'should return 0 if no points earned yet' do
      points = user.sum_difficulty_points
      points.should == 0
    end
 
    it "should sum points from a user's solutions" do
      mock_solution = mock_model(Solution, {problem: Problem.new(difficulty: 3)})
      user.stub(:solutions).and_return([mock_solution]*2)
      user.sum_difficulty_points.should == 6
    end
  end

  describe '#update_score' do
    it 'should include the sum of all problem difficulty points in its calculation' do
      user.stub(:update_attribute)
      user.stub(:upvotes).and_return([])
      user.stub(:downvotes).and_return([])
      mock_solution = mock_model(Solution, {problem: Problem.new(difficulty: 3)})
      user.stub(:solutions).and_return([mock_solution]*2)

      user.should_receive(:update_attribute).with(:score, 6)

      user.update_score
    end
  end
end
