# testing functionality of eete package
library(testthat)

# Load necessary libraries
library(devtools)
library(tidyverse)
library(dplyr)
library(boot)

# Load the eete package
library(eete)

# loading simulation functions
source("C:/Users/jonat/OneDrive/economics_research/simulation_analysis/R/simulation_functions.R")

parameters = c(6, 0.1, 1.25, 1.1)

mu = parameters[1]
zeta = parameters[2]
sigma = parameters[3]
lambda = parameters[4]

test_that("eete doesn't return null", {
  test_df = generate_simulations(mu, zeta, sigma, lambda)
  result = eete(crpie, gam = 2, y = "values", d = "treatment", data = test_df)
  nulls = !anyNA(result)
  expect_equal(nulls, TRUE)
})

test_that("eete bootstrapped standard error not null", {
  
  test_df = generate_simulations(mu, zeta, sigma, lambda)
  
  result = eete(crpie, gam = 2, y = "values", d = "treatment", data = test_df, se = "boot")
  not_null = !is.null(result$se)
  expect_equal(not_null, TRUE)
})


test_that("eete calculates arithmetic mean for gamma = 0", {
  
  # generate the simulation and control data
  random = runif(5, min = 0.1, max = 5)
  control = c(1, 1, 1, 1, 1)
  values = c(random, control)
  treatment = c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
  
  df = data.frame(values, treatment)
  
  # arithmetic mean should be equivalent to eete with gamma = 0
  arith_th = mean(df$values[1:5]) - 1
  arith_ee = eete(crpie, 0, y = "values", d = "treatment", data = df)
  expect_equal(arith_th, arith_ee$estimate)
})


test_that("eete calculates geometric mean for gamma = 1", {
  
  # generate the simulation and control data
  random = runif(5, min = 0.1, max = 5)
  control = c(1, 1, 1, 1, 1)
  values = c(random, control)
  treatment = c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
  
  df = data.frame(values, treatment)
  
  geo_th = exp(mean(log(df$values[1:5]))) - 1
  geo_ee = eete(crpie, 1, y = "values", d = "treatment", data = df)
  expect_equal(geo_th, geo_ee$estimate)
})

test_that("eete calculates harmonic mean for gamma = 2", {
  
  # generate the simulation and control data
  random = runif(5, min = 0.1, max = 5)
  control = c(1, 1, 1, 1, 1)
  values = c(random, control)
  treatment = c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0)
  
  df = data.frame(values, treatment)
  
  harm_th = (5 / sum(1 / df$values[1:5])) - 1
  harm_ee = eete(crpie, 2, y = "values", d = "treatment", data = df)
  expect_equal(harm_th, harm_ee$estimate)
})
