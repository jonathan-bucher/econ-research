
library(devtools)
library(tidyverse)

# devtools::install_github("mkairy/eete")

library(eete)

# load simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation_functions.R")

# define parameters
parameters = c(6, 0.1, 1.25, 1.1)

mu = parameters[1]
zeta = parameters[2]
sigma = parameters[3]
lambda = parameters[4]
# gamma = 0

gammas = c(0, 0.25, .5, .75, 1, 1.25, 1.75, 2, 2.25, 2.5, 2.75, 3, 4, 5, 6, 7, 8, 9, 10)

# run simulations

folder = "C:/Users/jonat/OneDrive/economics_research/simulation_analysis/visualizations/eete_histograms"


emp_ee(mu, zeta, sigma, lambda, gamma = 0, 10, hist = TRUE, output_folder = folder)


for (gamma in gammas) {
  
  emp_ee(mu, zeta, sigma, lambda, gamma, n = 10000, hist = TRUE, output_folder = folder) 
  
}

  