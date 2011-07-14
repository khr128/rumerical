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

    @gaussj
  Scenario: Gauss-Jordan elimination
    Given matrix is initialized with the following elements:
      | i | j | value |
      | 1 | 1 | 1     |
      | 1 | 2 | 1.5   |
      | 1 | 3 | 1.8   |
      | 2 | 1 | -1.1  |
      | 2 | 2 | 2.5   |
      | 2 | 3 | 2.8   |
      | 3 | 1 | -11.1 |
      | 3 | 2 | 12.5  |
      | 3 | 3 | -1.8  |
    And matrix "right_parts" is initialized with the following elements:
      | i | j | value |
      | 1 | 1 | 1     |
      | 2 | 1 | 7     |
      | 3 | 1 | -2.3  |
      | 1 | 2 | -1    |
      | 2 | 2 | 3     |
      | 3 | 2 | 1.3   |
    And I apply Gauss-Jordan elimination on matrix with matrix of "right_parts"

    Then I have inverse matrix for the matrix
    And I have solutions for the "right_parts"
