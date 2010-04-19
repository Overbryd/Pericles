Feature: add user

  Scenario: add a new user
    When I visit "/"
     And I follow "Add"
     And I fill in "name" with "chuck"
     And I fill in "password" with "norris"
     And I press "Create"
    When I visit "/"
    Then I should see "chuck"
  
  Scenario: trying to add an existing user
    Given a user "chuck/norris"
    When I visit "/"
     And I follow "Add"
     And I fill in "name" with "chuck"
     And I fill in "password" with "norris"
     And I press "Create"
    Then I should see "User already exists"