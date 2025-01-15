# Egalitarian Equivalent Treatment Effect: Simulation and Testing

## Project Overview
This project focuses on testing a [software package](https://github.com/mkairy/eete) that computes the egalitarian equivalent treatment effect (EETE). The codebase is designed to:

1. Simulate data for treatment and control groups.
2. Cache visualizations to facilitate analysis of results.
3. Implement and validate the computation of EETE.

---

## File Structure

### `simulation.R`
**Purpose**: Contains functions to generate simulated data for treatment and control groups and to cache visualizations.

#### Key Functions:
- `generate_simulations(mu, sigma, lambda, gamma)`:
  Simulates 1000 samples from a lognnormal distribution, applying the specified `treatment_effect` for the treatment group.

- `emp_ee(n, mu, sigma, lambda, gamma)`:
  Utilizes the eete package to calculate the eete of n simulations.
---

### `eete.R`, `se.R`, `qq_plot.R`
**Purpose**: various scripts applying simulation functions to to test the eete packages functionality in the following ways;

- compare estimated eete values to theoretical benchmarks for various parameter values
- verify accuracy of bootstrapped standard error calculations
- plot quantiles of theoretical error distributions against those observed

---

### `visualizations.R`
**Purpose**: store visualizations of the tests run above for ease of analysis.

- Histograms of estimation errors
- scatterplots of standard error estimations
- qq plots
---

