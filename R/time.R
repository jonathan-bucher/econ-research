# time profiling of eete package

# Load necessary libraries
library(devtools)
library(tidyverse)
library(dplyr)
library(boot)

# Load the eete package
library(eete)

# loading simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation_functions.R")



start = proc.time()

test_df = generate_simulations(mu, zeta, sigma, lambda)

result = eete(crpie, gam = 2, y = "values", d = "treatment", data = test_df, se = "boot")

end = proc.time()

print(end - start)




start = proc.time()

# generate simulation data
simul_data = generate_simulations(mu, zeta, sigma, lambda)

# compute se
bootstrap_result = boot(
  data = simul_data,
  statistic = function(data, i) {
    
    eete(crpie, gamma, y = "values", d = "treatment", data = data[i, ])$estimate
  }, 
  R = 500
)

end = proc.time()

print(end - start)

