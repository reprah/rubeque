Then /^I should be on the problem page for "([^"]*)"$/ do |title|
  visit problem_path(Problem.where({title: title}).first)
end

When /I go to the problems page/ do
  visit problems_path
  1
end

Given /^the following problems:$/ do |table|
  Problem.delete_all
  table.hashes.each do |hash|
    problem = Problem.new(hash)
    problem.save :validate => false
  end
end

When /^I sort by "([^"]*)"$/ do |column|
  page.find(:xpath, "//table[@id='problems']//th[contains(., '#{column}')]").click
end

Then /^I should see problems in this order:$/ do |table|
  expected_order = table.raw
  actual_order = []

  rows = page.all('tr.problem')
  rows.each do |row|
    # We just want the first and third td in our cells array
    cells = row.all('td').select.with_index { |element, index| [0, 2].include? index }
    actual_order << cells.map { |cell| cell.text }
  end

  actual_order.should == expected_order
end

Given /^there is a problem with title "([^"]*)"$/ do |title|
  Factory(:problem, title: title)
end

Given /^the problem "([^"]*)" is followed by "([^"]*)"$/ do |title_1, title_2|
  problem_1 = Problem.where({title: title_1}).first
  problem_1.next_problem = Problem.where({title: title_2}).first
  problem_1.save!
end
