Feature: Creating an idea
  In order to contribute to the community
  As an user
  I want to create an idea

  @javascript @omniauth_test
  Scenario: View ideas for an issue
    Given I am logged in via Facebook
    And 1 issues exist
    And I have 1 idea category
    And I have 1 idea help method
    And I go to the first issue's ideas page
    And I click "Dê uma ideia"
    And I should see "Nova ideia"
    And I should see "Batize sua ideia"
    And I should see "Descreva-a em 140 caracteres (relaxa, você vai poder escrever mais depois)"
    And I should see "Categoria"
    When I fill in my idea information
    Then My idea should be created for that issue
