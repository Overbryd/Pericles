@authenticated
Feature: list users
  
  Scenario: list all users by login name
    Given a user "johnsmith/1234"
      And a user "johntravolta/test"
    When I visit "/users"
    Then I should see "johnsmith"
     And I should see "johntravolta"
  