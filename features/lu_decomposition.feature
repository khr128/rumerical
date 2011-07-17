@lu
Feature: LU Decomposition
  As a user of Rumerical gem
  I'd like to find lower and upper triangular matrices such that M = L*U
  So that I can compute determinant and solve sets of linear equations

 Background:
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

 Scenario: Perform LU decomposition
    When I perform LU decomposition of the matrix
    Then I have L and U matrices defined for the matrix

 Scenario: Perform LU decomposition and solve equations by back substitution
    When I perform LU decomposition of the matrix
    Then I have L and U matrices defined for the matrix

    And matrix "right_parts" is initialized with the following elements:
      | i | j | value |
      | 1 | 1 | 1     |
      | 2 | 1 | 7     |
      | 3 | 1 | -2.3  |

    When I perform LU back substitution with "right_parts"
    Then I have solutions for the "right_parts"

  Scenario: Calculate inverse matrix using LU decomposition
    When I perform LU decomposition of the matrix
    Then I have L and U matrices defined for the matrix
 
    When I perform LU matrix inversion
    Then I have inverse matrix for the matrix

