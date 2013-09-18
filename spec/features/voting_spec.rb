require 'spec_helper'

feature 'users can vote on solutions' do
  before(:each) do
    Problem.destroy_all
    User.destroy_all
    Vote.destroy_all
    problem = Problem.create!(title: "Test", difficulty: "Easy", code: "true", approved: true)
    user = User.create!(username: "testuser", email: "test@test.com", password: "hello12345", password_confirmation: "hello12345")
    solution_user = User.create!(username: "solutionuser", email: "solution@test.com", password: "hello12345", password_confirmation: "hello12345")
    user.update_attribute(:admin, true)
    Solution.any_instance.stub(run_problem: true)
    solution = Solution.new
    solution.problem = problem
    solution.user = solution_user
    solution.code = "true"
    solution.save!
  end

  scenario 'users can upvote', js: true do
    expect {
      login
      visit "/problems/test/solutions"
      page.should have_content "Solutions for"
      page.find(:css, ".upvote").click
      sleep 0.3
    }.to change { Solution.first.calculated_score }.from(1).to 2
  end

  scenario 'users can downvote after upvoting', js: true do
    login
    visit "/problems/test/solutions"
    page.should have_content "Solutions for"
    page.find(:css, ".upvote").click
    sleep 1
    expect {
      page.find(:css, ".downvote").click
      sleep 0.3
    }.to change { Vote.downvote.count }.from(0).to 1
  end

  scenario 'users can downvote', js: true do
    login
    expect {
      visit "/problems/test/solutions"
      page.find(:css, ".downvote").click
      sleep 0.3
    }.to change { Vote.downvote.count }.from(0).to 1
  end

  def login
    visit new_user_session_path
    fill_in "Username", with: "testuser"
    fill_in "Password", with: "hello12345"
    click_on "Sign in"
    page.should have_content "Problems"
  end
end
