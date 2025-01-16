# Egalitarian Equivalent Treatment Effect: Simulation and Testing

## Project Overview
This project focuses on testing the [eete software package](https://github.com/mkairy/eete), which was designed by my research team to estimate the egalitarian equivalent treatment effect (EETE). EETE is a way to measure the impact of a treatment (like a policy or intervention) by calculating how much of the benefit or harm could be evenly distributed among everyone, while still having the same overall effect. It focuses on fairness, aiming to assess the result as if everyone were equally affected.

My main goals were to demonstrate the following;

1. The estimated eete value was unbiased
2. The packages bootstrapping functions worked properly
3. The estimation errors were properly distributed according to theoretical benchmarks

The best way to see the results of these tests is to check out the [visualizations folder](https://github.com/jonathan-bucher/econ-research/tree/main/visualizations), where I represented these tests graphically for a variety of parameter values.

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
**Purpose:** various scripts applying simulation functions to to test the eete packages functionality in the following ways;

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

