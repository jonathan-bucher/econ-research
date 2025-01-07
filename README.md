# Egalitarian Equivalent Treatment Effect: Simulation and Testing

## Project Overview
This project focuses on testing a software package that computes the Egalitarian Equivalent Treatment Effect (EETE). The codebase is designed to:

1. Simulate data for treatment and control groups.
2. Cache visualizations to facilitate analysis of results.
3. Implement and validate the computation of EETE.

---

## File Structure

### 1. `simulation.R`
**Purpose**: Contains functions to generate simulated data for treatment and control groups and to cache visualizations.

#### Key Functions:
- `generate_simulations(mu, sigma, lambda, gamma)`:
  Simulates 1000 samples from a lognnormal distribution, applying the specified `treatment_effect` for the treatment group.

- `emp_ee(n, mu, sigma, lambda, gamma)`:
  Utilizes the eete package to calculate the eete of n simulations.
---

### 2. `eete.R`
**Purpose**: Compare estimated eete values to theoretical benchamrks for various parameter values.

---

### 3. `se.R`
**Purpose**: Verify accuracy of bootstrapped standard error calculations.

---

