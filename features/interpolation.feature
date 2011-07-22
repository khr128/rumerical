@ip
Feature: Interpolation

  As a user of rumerical gem
  I'd like to interpolate/extrapolate a set of (x[i],y[i]) values
  In order to find approximations for y(x) at arbitrary x

Scenario: Interpolate cubic function
    Given an interpolation object
    When I set interpolation points to:
      | x   | y      |
      | 1.0 | 1.0    |
      | 1.5 | 3.375  |
      | 2.0 | 8.0    |
      | 2.5 | 15.625 |
      | 3.0 | 27.0   |
    
    Then I should get the following interpolated values using polinomial interpolation:
      | x   | y      | eps    | order | offset |
      | 0.9 | 0.729  | 1.0e-6 | 5     | 0      |
      | 1.2 | 1.728  | 1.0e-6 | 5     | 0      |
      | 1.6 | 4.096  | 5.0e-8 | 5     | 0      |
      | 2.1 | 9.261  | 5.0e-8 | 5     | 0      |
      | 2.0 | 8.0    | 1.0e-6 | 3     | 2      |
      | 2.1 | 9.261  | 1.0e-6 | 4     | 1      |
      | 2.5 | 15.625 | 1.0e-6 | 3     | 2      |
      | 3.0 | 27.0   | 1.0e-6 | 3     | 2      |
      | 3.2 | 32.768 | 1.0e-6 | 5     | 0      |
