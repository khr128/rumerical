Feature: Matrix

  As a user of Rumerical gem
  I'd like to initialize and use matrix
  To do linear algebra calculations

  Scenario: Empty Matrix initialization
  Given matrix is initialized with the following elements:
    | i | j | value |
  Then the matrix has the following elements:
    | i  | j  | value |
    | 1  | 1  | 0     |
    | 42 | 37 | 0     |


  @init
  Scenario: Matrix initialization
  Given matrix is initialized with the following elements:
    | i | j | value |
    | 1 | 1 | 1     |
    | 2 | 2 | 2     |
    | 3 | 3 | 3     |
  Then the matrix has the following elements:
    | i  | j  | value |
    | 1  | 1  | 1     |
    | 1  | 2  | 0     |
    | 2  | 2  | 2     |
    | 3  | 3  | 3     |
    | 2  | 3  | 0     |
    | 42 | 37 | 0     |

  Scenario: Matrix multiplication
    Given matrix is initialized with the following elements:
      | i | j | value |
      | 1 | 1 | 1     |
      | 1 | 2 | 1     |
    And matrix "1" is initialized with the following elements:
      | i | j | value |
      | 1 | 1 | 0.5   |
      | 2 | 1 | 0.25  |
    When I multiply the matrix and the matrix "1"
    Then the matrix "result" has the folowing elements:
      | i | j | value |
      | 1 | 1 | 0.75  |
      | 2 | 1 | 0     |
      | 1 | 2 | 0     |
      | 2 | 2 | 0     |
