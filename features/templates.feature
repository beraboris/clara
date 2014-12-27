Feature: File templates
  Files should be processed with ERB

  Scenario: Simple ERB template
    Given I have a file named "/packages/facts.txt" containing
    """
    ---
    system_location: /etc/facts.txt
    user_location: ~/.facts.txt
    ---
    The answer to life is <%= 42 %>. What is the question?
    """
    When I install "/packages/facts.txt"
    Then I should find "~/.facts.txt" containing
    """
    The answer to life is 42. What is the question?
    """