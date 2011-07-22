@int
Feature: Integration

  As a usr of rumerical gem
  I'd like to calculate definite integrals
  For any purpose that I might have

  Scenario: Integrate function using extended trapezoid rule
    Given an integration object with the following parameters:
      | a   | b   | func |
      | 1.0 | 2.0 | x*x  |
    Then I apply extended trapezoid rule successively with the following results:
      | n  | integral  | eps    |
      | 1  | 2.33333   | 2.0e-1 |
      | 2  | 2.33333   | 1.0e-1 |
      | 3  | 2.33333   | 4.0e-2 |
      | 4  | 2.33333   | 2.0e-2 |
      | 5  | 2.33333   | 1.0e-2 |
      | 6  | 2.33333   | 5.0e-3 |
      | 7  | 2.33333   | 3.0e-3 |
      | 8  | 2.33333   | 1.1e-3 |
      | 9  | 2.33333   | 5.0e-4 |
      | 10 | 2.33333   | 2.5e-4 |
      | 11 | 2.33333   | 1.3e-4 |
      | 12 | 2.33333   | 6.5e-5 |
      | 13 | 2.33333   | 3.4e-5 |
      | 14 | 2.3333333 | 1.6e-5 |
      | 15 | 2.3333333 | 8.0e-6 |
      | 16 | 2.3333333 | 4.0e-6 |

@qromb
  Scenario: Integrate function using Romberg's method
    Given an integration object with the following parameters:
      | a   | b   | func |
      | 1.0 | 2.0 | x*x  |
    Then I apply Romberg's method with the following parameters:
      | K | eps     | integral           |
      | 5 | 1.0e-8  | 2.3333333333333333 |
      | 4 | 1.0e-14 | 2.3333333333333333 |

@qromb_2
  Scenario: Integrate cos function using Romberg's method
    Given an integration object with the following parameters:
      | a   | b   | func         |
      | 1.0 | 3.0 | Math::cos(x) |
    Then I apply Romberg's method with the following parameters:
      | K | eps     | integral             |
      | 5 | 1.0e-14 | -0.70035097674802933 |
      | 6 | 1.0e-14 | -0.70035097674802933 |
      | 7 | 1.0e-15 | -0.70035097674802933 |
