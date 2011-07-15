Feature: Gauss-Jordan elimination

  As a user of Rumerical gem
  I'd like to use Gauss-Jordan elimination with pivoting
  To solve sets of linear equations and to compute inverse matrices
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
