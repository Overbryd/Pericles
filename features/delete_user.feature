@authenticated
Feature: delete user
  
  Scenario: delete a user
    Given a user "monkey/funkey"
    When I visit "/users"
     And I press "delete"
    When I visit "/users"
    Then I should not see "monkey"