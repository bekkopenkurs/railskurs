Feature: Show course
  In order to get information about the course
  As a student
  I want to have a page with all the information neatly presented

  Scenario: Show course details
    Given a valid course exist
    And I am on the course details page
    Then I should see the course's code
    And I should see a course's name
    And I should see the course's credits
    And I should see how many assessments there are in the course
    And I should see how many mandatory activities there are in the course
    And I should see the name of the teacher for the course
