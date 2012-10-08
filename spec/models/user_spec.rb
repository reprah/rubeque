require 'spec_helper'

describe User do
  describe "first unsolved problem" do

    before do
      @user = User.create!(name: 'Juan', email: 'juan@gmail.mx', password: 'mexico', username: 'juantwo')
      @first_problem = Problem.create!(difficulty: 0,
                                title: "The Truth",
                                tag_list: "booleans",
                                instructions: "Here's a hint: true equals true.",
                                code: "assert_equal true, ___",
                                approved: true,
                                order_number: 0
                               )
      @second_problem = Problem.create!(difficulty: 0,
                                       title: "Hello World",
                                       instructions: "",
                                       tag_list: "strings",
                                       code: "assert_equal 'HELLO WORLD', 'hello world'.___",
                                       approved: true,
                                       order_number: 1
                                      )
      @third_problem = Problem.create!(difficulty: 0,
                                       title: "Nil Values",
                                       instructions: "Enter in a boolean value for what #nil? will return.",
                                       tag_list: "nil, booleans",
                                       code: "[0, '', 'chunky_bacon'].each { |v| assert_equal v.nil?, ___ }",
                                       approved: true,
                                       order_number: 2
                                      )
    end

    it "is the first problem if no problems have been solved" do
      expect(@user.first_unsolved_problem).to eq(@first_problem)
    end

    it "is the second problem if the first problem has been solved" do
      Solution.any_instance.stub(run_problem: true)
      solution = Solution.new
      solution.problem = @first_problem
      solution.user = @user
      solution.save!

      expect(@user.first_unsolved_problem).to eq(@second_problem)
    end

    it "is the first problem if the second and third problem have been solved" do
      Solution.any_instance.stub(run_problem: true)
      solution = Solution.new
      solution.problem = @second_problem
      solution.user = @user
      solution.save!
      solution2 = Solution.new
      solution2.problem = @third_problem
      solution2.user = @user
      solution2.save!

      expect(@user.first_unsolved_problem).to eq(@first_problem)
    end

    it "is the third problem if the first and second problem have been solved" do
      Solution.any_instance.stub(run_problem: true)
      solution = Solution.new
      solution.problem = @first_problem
      solution.user = @user
      solution.save!
      solution2 = Solution.new
      solution2.problem = @second_problem
      solution2.user = @user
      solution2.save!

      expect(@user.first_unsolved_problem).to eq(@third_problem)
    end
  end
end
