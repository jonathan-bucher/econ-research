# testing simulation results
library(testthat)

# Load necessary libraries
library(devtools)
library(tidyverse)
library(dplyr)
library(boot)

# Load the eete package
library(eete)

# load simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation_functions.R")

# we are using Meager's model to generate our test distribution
# yi(Ti) ~ LogNormal(mu + (zeta * Ti), (sigma * (lambda) ^ (Ti)))

# [mu, zeta, sigma, lambda] = [6, 0.1, 1.25, 1.1]
parameters = c(6, 0.1, 1.25, 1.1)

mu = parameters[1]
zeta = parameters[2]
sigma = parameters[3]
lambda = parameters[4]
gammas = c(0, 0.25, .5, .75, 1, 1.25, 1.75, 2, 2.25, 2.5, 2.75, 3, 4, 5, 6, 7, 8, 9, 10)

test_df = generate_simulations(mu, zeta, sigma, lambda)

test_that("simulation has proper length", {
  expect_equal(length(test_df$values), 2000)
  expect_equal(length(test_df$treatment), 2000)
})

test_that("values not null", {
  result = !anyNA(test_df$values)
  expect_equal(result, TRUE)
})

test_that("treatment not null", {
  result = !anyNA(test_df$treatment)
  expect_equal(all(result), TRUE)
})

test_that("first 1000 treatments are 0 indicating control", {
  result = test_df$treatment[1:1000] == 0
  expect_equal(all(result), TRUE)
})

test_that("second 1000 treatments are 1 indicating treatment", {
  result = test_df$treatment[1001:2000] == 1
  expect_equal(all(result), TRUE)
})

test_that("egalitarian equivalent for treatment = 1", {
  result = theory_ee(1, mu, zeta, sigma, lambda, 2)
  expect_equal(result, 173.21, tolerance = 0.1)
})

test_that("egalitarian equivalent for treatment = 0", {
  result = theory_ee(1, mu, zeta, sigma, lambda, 2)
  expect_equal(result, 184.71, tolerance = 0.1)
})

test_that("emp_ee return list is proper length", {
  result = emp_ee(mu, zeta, sigma, lambda, 2, 10)
  expect_equal(length(result), 10)
})

# testing histograme
test_that("histograms are created", {
  
  data = generate_simulations(mu, zeta, sigma, lambda)$values
  
  # temporary directory
  temp_dir = tempdir()
  
  cache_histogram(data, 0, theory_eete = 0, temp_dir)
  
  # check if file exists
  files = list.files(temp_dir, pattern = "\\.png$", full.names = TRUE)
  expect_equal(length(files), 1)
  
  # check if file is valid image
  file_size = file.info(files)$size
  nonzero = (file_size > 0)
  expect_equal(nonzero, TRUE)
  
  file.remove(files)
  
})

test_that("proper file structure", {
  
  false_dir = "random_folder"
  data = generate_simulations(mu, zeta, sigma, lambda)$values
  
  expect_error(cache_histogram(x = data, gamma = 0, theory_eete = 0, output_folder = false_dir), "output folder is not a valid directory")
  
})

test_that("nested cache_histograms", {
  
  temp_dir = tempdir()
  
  emp_ee(mu, zeta, sigma, lambda, 2, 10, hist = TRUE, output_folder = temp_dir)
  
  # check if file exists
  files = list.files(temp_dir, pattern = "\\.png$", full.names = TRUE)
  expect_equal(length(files), 1)
  
  # check if file is valid image
  file_size = file.info(files)$size
  nonzero = (file_size > 0)
  expect_equal(nonzero, TRUE)
  
  file.remove(files)
  
})


# testing standard error

test_that("standard error functionality", {
  
  result = eete(crpie, gam = 2, y = "values", d = "treatment", data = test_df, se = "boot")
  expect_equal(length(result), 2)
  
})

test_that("bootstrapping library functionality", {
  
  df = generate_simulations(mu, zeta, sigma, lambda)
  custom_estimator = function(data){
    mean_treatment = mean(data$values[data$treatment == 1])
    mean_control = mean(data$values[data$treatment == 0])
    return(mean_treatment - mean_control)
  }
  
  bootstrap_result = boot(
    data = df,
    statistic = function(data, i) custom_estimator(data[i, ]),
    R = 1000
  )
  
  se_bootstrap = sd(bootstrap_result$t)
  expect_equal(TRUE, is.numeric(se_bootstrap))
  
})

test_that("bootstrapping test function output", {
  result = bootstrapping(mu, zeta, sigma, lambda, 0, 2)
  expect_equal(length(result$package_se), 2)
})












