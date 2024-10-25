Feature: Edit books

Add a scenario to check if Amber can accept pending recomendations

Scenario: As Amber I should be able to edit a book's title
    Given I have two users Amber and mary
    And I have books
    And I log in as Amber
    When I click "Edit" on the first book
    And I edit the book's title
    Then I should be able to see the edit

Scenario: As Amber I should be able to edit a book's read status
    Given I have two users Amber and mary
    And I have books
    And I log in as Amber
    When I click "Edit" on the first book
    And I edit the book's read status
    Then I should be able to see the edit