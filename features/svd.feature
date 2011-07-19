@svd
Feature: Singular Value Decomposition

  As a user of Rumerical gem
  I'd like to perform Singular Value Decomposition on matrix
  In order to be able to solve ill-defined linear algebra problems

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

  Scenario: Perform Singular Value Decomposition
    When I perform singular value decomposition of the matrix
    Then I have singular value decomposition of the matrix
    
