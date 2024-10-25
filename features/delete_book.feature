Feature: Delete books

Nothing to do Amber is the only one who can delete books

Scenario: As Amber I should be able to delete a book
    Given I have two users Amber and mary
    And I have books
    And I log in as Amber
    When I click "Destroy" on the first book
    Then I should be able to see the deleted book