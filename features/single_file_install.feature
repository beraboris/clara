Feature: Single file installation
  Single config files should be installable as packages

  Scenario: Root installation
    Given I have a file named "/packages/thing.conf" containing
    """
    ---
    root_destination: /etc/thing.conf
    home_destination: ~/.thing.conf
    ---
    Hi mom
    """
    When I install "/packages/thing.conf" system wide
    Then I should find "/etc/thing.conf" containing
    """
    Hi mom
    """

  Scenario: Home installation
    Given I have a file named "/packages/other_thing.conf" containing
    """
    ---
    root_destination: /etc/other_thing.conf
    home_destination: ~/.other_thing.conf
    ---
    Hi dad
    """
    When I install "/packages/other_thing.conf" for my user
    Then I should find "~/.other_thing.conf" containing
    """
    Hi dad
    """

  Scenario: Installation without home or system specified
    Given I have a file named "/packages/that_thing.conf" containing
    """
    ---
    root_destination: /etc/that_thing.conf
    home_destination: ~/.that_thing.conf
    ---
    Hey there
    """
    When I install "/packages/that_thing.conf" for my user
    Then I should find "~/.that_thing.conf" containing
    """
    Hey there
    """