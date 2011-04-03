Feature: Create course
  In order to manage my courses
  As a student
  I want to be able to create a new course

  Scenario: Register new course
    Given I am on the home page
    When I fill in "TDT4220" for "course_code"
    And I press "Get course"
    Then I should be on the new course page
    And I should see "TDT4220"