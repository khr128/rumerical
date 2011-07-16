@lu
Feature: LU Decomposition
  As a user of Rumerical gem
  I'd like to find lower and upper triangular matrices such that M = L*U
  So that I can compute determinant and solve sets of linear equations

 Scenario: Perform LU decomposition
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

    When I perform LU decomposition of the matrix
    Then I have L and U matrices defined for the matrix
