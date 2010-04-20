Feature: authentication
  
  Scenario: not authenticated
    When I visit "/"
    Then I should not see "Add User"
    Then I should not see "Browse"
  
  @authenticated
  Scenario: authenticated
    When I visit "/"
    Then I should see "Add User"
    Then I should see "Browse"