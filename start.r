# Set up environment
rm(list = ls())         # Clear workspace
set.seed(45678)         # Set random seed
library(ggplot2)        # For plotting
library(forecast)       # For time series analysis

# Set working directory (modify path as needed)
setwd("/Users/Freddie/Documents/Uni Shit/2025/ECON412/Assignment 1/")

# Start logging (uncomment to use)
# sink("Assgn1.log", append = FALSE, split = TRUE)

# Create time variable (0-100)
df <- data.frame(t = 0:100)

# Generate et: 0 for t=0, N(0,1) for t>0
df$et <- c(0, rnorm(100))  # First element is 0, then 100 normal variates

# Summary statistics
cat("Summary of et:\n")
print(summary(df$et[-1]))  # Exclude initial 0

# List first 100 observations (t=0 to t=100)
cat("\nFirst 100 observations:\n")
print(head(df, 101))

# ACF plot for t>0 (equivalent to Stata's ac et in 2/101)
acf_values <- acf(df$et[-1], lag.max = 20, plot = FALSE)
plot(acf_values, main = "ACF of et", xlab = "Lag", ylab = "Autocorrelation")

# Generate x1t (simple copy of et)
df$x1t <- df$et

# Generate x3t (AR(1) process with phi=0.5)
df$x3t <- numeric(nrow(df))
for(i in 2:nrow(df)) {
    df$x3t[i] <- 0.5 * df$x3t[i-1] + df$et[i]
}

# Time series plot of x3t
ggplot(df, aes(t, x3t)) + 
    geom_line() + 
    geom_point() +
    labs(title = "x3t Time Series Plot")

# ACF and PACF for x3t (t>0)
acf(df$x3t[-1], lag.max = 20, main = "ACF of x3t")
pacf(df$x3t[-1], lag.max = 20, main = "PACF of x3t")

# ARIMA estimation (equivalent to Stata's arima)
arima_fit <- arima(df$x3t[-1], order = c(1, 0, 0))  # AR(1) model
print(summary(arima_fit))

# Ljung-Box test (equivalent to wntestq)
Box.test(residuals(arima_fit), lag = 20, type = "Ljung-Box")

# End logging
# sink()
