
# Load necessary libraries
library(devtools)
library(tidyverse)
library(dplyr)

# Load the eete package
library(eete)

# load simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation_functions.R")


# testing the distribution of the eete

parameters = c(6, 0.1, 1.25, 1.1)

mu = parameters[1]
zeta = parameters[2]
sigma = parameters[3]
lambda = parameters[4]
gammas = c(0, 0.25, .5, .75, 1, 1.25, 1.75, 2, 2.25, 2.5, 2.75, 3, 4, 5, 6, 7, 8, 9, 10)

se_folder = "C:/Users/jonat/OneDrive/economics_research/simulation_analysis/visualizations/eete_bootse_scatterplots"

# testing the standard error
se = bootstrapping(mu, zeta, sigma, lambda, 0, 5, scatterplot = TRUE, output_folder = se_folder)


hist_folder = "C:/Users/jonat/OneDrive/economics_research/simulation_analysis/visualizations/eete_histograms"


for (gamma in gammas) {
  
  emp_ee(mu, zeta, sigma, lambda, gamma, n = 10000, hist = TRUE, output_folder = hist_folder)
  
}













