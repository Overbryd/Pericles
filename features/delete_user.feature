Feature: delete user
  
  Scenario: delete a user
    Given a user "monkey/funkey"
    When I visit "/"
     And I press "delete"
    When I visit "/"
    Then I should not see "monkey"