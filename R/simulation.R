# Load necessary libraries
library(devtools)
library(tidyverse)
library(boot)

# devtools::install_github("mkairy/eete")

# Load the eete package
library(eete)


# conducting simulation analysis

generate_simulations <- function(mu, zeta, sigma, lambda){
  
  # generating a distribution with treatment = 0
  control <- rlnorm(1000, mu, sigma)
  
  # generating a distribution with treatment = 1
  treatment <- rlnorm(1000, mu + zeta, sigma * lambda)
  
  # join these two lists together
  values = c(control, treatment)
  
  # create an indicator column with 0 for control, 1 for treatment
  indicator = c(replicate(1000, 0), replicate(1000, 1))
  
  # combine these columns into a dataframe
  simulation.data <- data.frame(
    values = values,
    treatment = indicator
  )
  
  return(simulation.data)
}

# solution should be centered around the closed form for the egalitarian equivalent of y(d), defined as follows
# EE(y(d)) = exp(mu + (zeta * d) + [(1/2) * (1 - gamma) * (sigma * (lambda ^ d))^2]), for d in {0, 1}

theory_ee <- function(d, mu, zeta, sigma, lambda, gamma){
  
  result <- exp(mu + (zeta * d) + (0.5 * (1 - gamma) * (sigma * (lambda ^ d)) ^ 2))
  
  return(result)
}


emp_ee = function(mu, zeta, sigma, lambda, gamma, n, hist = FALSE, output_folder = FALSE){
  
  # create list for storing 10000 eete values
  eetes = numeric(n)
  
  # run the simulation n times
  for (i in 1:n) {
    
    # generate simulation (returns a data frame with two columns, treatment and control)
    simul_data = generate_simulations(mu, zeta, sigma, lambda)
    
    # compute eete
    treatment_effect = eete(crpie, gamma, y = "values", d = "treatment", data = simul_data)
    
    # store values
    eetes[i] = treatment_effect$estimate
  }
  
  # generate histograms
  if (hist){
    
    # compute theoretical eete
    treat_ee = theory_ee(1, mu, zeta, sigma, lambda, gamma)
    control_ee = theory_ee(0, mu, zeta, sigma, lambda, gamma)
    theory_eete = treat_ee - control_ee
    
    cache_histogram(eetes, gamma, theory_eete, output_folder)
  }
  
  # return a list with the vectors of eete values in the first place
  return(eetes)
}


bootstrapping = function(mu, zeta, sigma, lambda, gamma, n, scatterplot = FALSE, output_folder = FALSE){
  
  # create list for n storing n se values
  package_se = vector(length = n)
  benchmark_se = vector(length = n)
  
  df = data.frame(package_se, benchmark_se)
  
  # run the simulation n times
  for (i in 1:n) {
    
    # generate simulation data
    simul_data = generate_simulations(mu, zeta, sigma, lambda)
    
    # compute se
    treatment_effect = eete(crpie, gamma, y = "values", d = "treatment", data = simul_data, se = "boot")
    bootstrap_result = boot(
      data = simul_data,
      statistic = function(data, i) {
        
        eete(crpie, gamma, y = "values", d = "treatment", data = data[i, ])$estimate
      }, 
      R = 500
    )
    
    # store values
    df[i, "package_se"] = treatment_effect$se
    df[i, "benchmark_se"] = sd(bootstrap_result$t)
  }
  
  if (scatterplot) {
    
    cache_scatterplot(df, gamma, output_folder)
    
  }
  
  return(df)
}

cache_histogram = function(x, gamma, theory_eete, output_folder){
  
  # folder to save the histograms
  if (!dir.exists(output_folder)) {
    stop("output folder is not a valid directory")
  }
  
  # create and save the histogram
  file_name = paste0(output_folder, "/", "gamma=", gamma, ".png")
  
  png(file_name)  # open a graphics device for saving
  
  # create a histogram
  hist(x, main = paste("Simulated Eete for Gamma = ", gamma), xlab = "Eete")
  
  # add a vertical line for the expected value
  abline(v = theory_eete, col = "black", lwd = 2, lty = 1)
  
  # add a vertical line for the observed value
  abline(v = mean(x), col = "red", lwd = 2, lty = 2)
  
  # add a legend
  legend("topright", legend = c("Theoretical Eete", "Simulated Eete"), 
         col = c("black", "red"), lty = c(1, 2), lwd = 2)
  
  dev.off()       # close the graphics device
  
  cat("Histogram saved as", file_name, "\n")
}


cache_scatterplot = function(std_errs, gamma, output_folder){
  
  # output_folder exists
  if (!dir.exists(output_folder)) {
    stop("output folder is not a valid directory")
  }
  
  file_name = paste0(output_folder, "/", "gamma=", gamma, ".png")
  
  png(file_name)
  
  plot(x = std_errs$benchmark_se, 
       y = std_errs$package_se, 
       main = paste("Bootstrapped Standard Error for EETE, Gamma = ", gamma), 
       xlab = "benchmark", 
       ylab = "package")
  
  abline(lm(package_se ~ benchmark_se, data = std_errs), col = "red", lwd = 2)
  
  dev.off()
  
  cat("Scatterplot saved as", file_name, "\n")
  
}



  
  