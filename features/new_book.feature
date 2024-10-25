Feature: Create books

Add a Scenario to create book recomendations as a Normal User

Scenario: As Amber I should be able to create a book
    Given I have two users Amber and mary
    And I log in as Amber
    When I click "New Book"
    And I fill out the new book form with "Ambers title"
    Then I should be able to see the new book

Scenario: As Amber I should be able to accept a pending book
    Given I have two users Amber and mary
    And I have books
    And I log in as Amber
    When I go to the homepage
    And I click "accept" on the first pending book
    Then I should be able to see that book as non-pending

Scenario: As Amber I should be able to reject a pending book
    Given I have two users Amber and mary
    And I have books
    And I log in as Amber
    When I go to the homepage
    And I click "reject" on the first pending book
    Then I should be able to see the deleted book

Scenario: As a normal user I should be able to create a book recommendation
    Given I have two users Amber and mary
    And I log in as mary
    When I click "New Book"
    And I fill out the new book form with "Some book title"
    Then I should be able to see the new book recommendation message
    And The book is pending approval from Amber