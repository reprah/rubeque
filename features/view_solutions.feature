Feature: View solutions for no points
  In order to solve a problem they are stuck on
  a user wants to view solutions
  and forfeit their automatic points

  Scenario: An external user tries to view solutions before solving a problem
    When I go to the problem page for "The Truth"
    Then I should not see "View Solutions"
    When I try to view solutions for "The Truth"
    Then I should be on the problem page for "The Truth"

  Scenario: A logged in user views solutions before solving a problem
    Given I am logged in as a user named "rubeque"
    When I go to the problem page for "The Truth"
    And I follow "View Solutions"
    Then I should see "Solutions for The Truth"
    When I go to the problem page for "The Truth"
    And I fill in "true" for the solution code
    And I submit the solution
    Then my score should not be increased

  Scenario: A logged in user solves a problem without viewing solutions
    Given I am logged in as a user named "rubeque"
    When I go to the problem page for "The Truth"
    When I fill in "true" for the solution code
    And I submit the solution
    Then my score should be increased
