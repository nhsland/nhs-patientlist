Feature: Managing team membership
  As a user
  I want to be able to manage the teams I am part of
  So that I can correctly help patients my teams are responsible for

  Background:
    Given I am a logged in member of staff

  Scenario: Joining a team
    Given I am viewing the teams page
    When I join the "Clinical" - "On Call" team
    Then I should be a member of the team
    And I should not be able to join the team twice
