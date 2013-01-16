Feature: Managing tasks
  As a member of the medical staff
  I want to be able to manage tasks
  So that I can ensure the patient receives the correct treatment they need

  Background:
    Given I am a logged in member of staff

  Scenario: Creating a task for a patient that hasn't been discharged
    Given there is a patient list with a patient
    And I am viewing the patient list
    When I add the task "Blood Sample"
    Then the patient will have a todo task "Blood Sample"

  Scenario: Marking an existing task as pending
    Given there is a patient list with a patient
    And I am viewing the patient list
    When I add the task "Blood Sample"
    And I mark the task "Blood Sample" as pending
    Then the patient will have a pending task "Blood Sample"

  Scenario: Marking an existing task as done
    Given there is a patient list with a patient
    And I am viewing the patient list
    When I add the task "Blood Sample"
    And I mark the task "Blood Sample" as done
    Then the patient will have a done task "Blood Sample"

  Scenario: Handing a task over to another list
    Given there is a patient list with a patient
      And that list has a task "Blood Sample"
      And there is another patient list
    When I start the handover for the list
      And I mark the task "Blood Sample" to hand over
      And I select another patient list to hand over to
    Then the other patient list will have a task "Blood Sample"
