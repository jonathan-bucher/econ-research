# creating a distribution for the estimator error

# Load necessary libraries
library(devtools)
library(tidyverse)
library(dplyr)

# Load the eete package
library(eete)

# load simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation.R")

parameters = c(6, 0.1, 1.25, 1.1)

mu = parameters[1]
zeta = parameters[2]
sigma = parameters[3]
lambda = parameters[4]
gammas = c(0, 0.25, .5, .75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 4, 5, 6, 7, 8, 9, 10)

output_folder = "C:/Users/jonat/OneDrive/economics_research/simulation_analysis/visualizations/error_distributions"


for (gamma in gammas){
  
  # estimated eete
  est = emp_ee(mu, zeta, sigma, lambda, gamma, 10000)
  
  # theoretical eete
  treat_ee = theory_ee(1, mu, zeta, sigma, lambda, gamma)
  control_ee = theory_ee(0, mu, zeta, sigma, lambda, gamma)
  theory = treat_ee - control_ee
  
  diff = (est - theory) * sqrt(10000)
  
  
  # distributions
  if (!dir.exists(output_folder)) {
    stop("output folder is not a valid directory")
  }
  
  # create and save the histogram
  file_name = paste0(output_folder, "/", "gamma=", gamma, ".png")
  
  png(file_name)  # open a graphics device for saving
  
  # create a histogram
  hist(diff, main = paste("Estimator Error for Gamma = ", gamma), xlab = "Error")
  
  # add a vertical line for the expected value
  abline(v = 0, col = "black", lwd = 2, lty = 1)
  
  # add a vertical line for the observed value
  abline(v = mean(diff), col = "red", lwd = 2, lty = 2)
  
  dev.off()       # close the graphics device
  
  cat("Histogram saved as", file_name, "\n")
  
}

