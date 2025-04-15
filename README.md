# Egalitarian Equivalent Treatment Effect: Simulation and Testing

## Project Overview
This project focuses on testing the [eete software package](https://github.com/mkairy/eete), which was designed by my research team to estimate the egalitarian equivalent treatment effect. EETE is a way to measure the impact of a policy by calculating how much of the benefit or harm could be evenly distributed among a population, while still having the same overall effect. It allows for a wide range of evaluator preferences with regard to inequality aversion, ranging frrom libertarian veiws, to a desire for complete equity.

My main goals were to demonstrate the following;

1. The estimated eete value was unbiased
2. The bootstrapping functions worked properly
3. The estimation errors were properly distributed according to theoretical benchmarks

Graphic representations of all these tests are stored in the [visualizations folder](https://github.com/jonathan-bucher/econ-research/tree/main/visualizations), and would be a good place to start for someone looking to get a broad overview of the project's results.

---

## File Structure

### simulation.R

Contains functions to simulate data for treatment and control groups and to cache visualizations.

#### Key Functions:
- `generate_simulations(mu, sigma, lambda, gamma)`:
  Simulates 1000 samples from a lognnormal distribution, applying the specified `treatment_effect` for the treatment group.

- `emp_ee(n, mu, sigma, lambda, gamma)`:
  Utilizes the eete package to calculate the eete of n simulations.
---

### eete.R, se.R, qq_plot.R

Various scripts applying simulation functions to to test the eete package functionality in the following ways;

- compare estimated eete values to theoretical benchmarks for various parameter values
- verify accuracy of bootstrapped standard error calculations
- plot quantiles of theoretical error distributions against those observed

---

### visualizations.R

Store visualizations of the tests run above for ease of analysis.

- Histograms of estimation errors
- scatterplots of standard error estimations
- qq plots
---

