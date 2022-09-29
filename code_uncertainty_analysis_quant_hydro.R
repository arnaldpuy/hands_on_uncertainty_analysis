## ----setup, include=FALSE------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- results="hide", message=FALSE, warning=FALSE-----

# install.packages(c("sensobol", "data.table", "tidyverse"))

library("sensobol")
library("data.table")
library("tidyverse")



## ----main_settings-------------------------------------

# MAIN SETTINGS ###############################################################

# Sample size
N <- 2^7

# Required matrices
matrices <- "A"

# Type of sample matrix
type <- "QRN"



## ----params--------------------------------------------
params <- c("x1", "x2")


## ----sobol_matrix, dependson="main_settings"-----------
mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)


## ---- inspect_matrix, dependson="sobol_matrix"---------
mat
plot(mat[, "x1"], mat[, "x2"])



## ----sampling_types, dependson="main_settings"---------
all_types <- c("QRN", "LHS", "R")



## ----plot_sampling_types, dependson="sampling_types", fig.height=3----

# Loop
prove <- lapply(all_types, function(type)
  sobol_matrices(matrices = matrices, N = N, params = params, type = type))

# Name
names(prove) <- all_types

# Plot
lapply(prove, data.table) %>%
  rbindlist(., idcol = "Method") %>%
  ggplot(., aes(x1, x2)) +
  geom_point() +
  facet_wrap(~Method)



## ----params2-------------------------------------------

params <- c("x1", "x2", "x3")


## ----sobol_matrix2, dependson="main_settings"----------

mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)


## ----model---------------------------------------------

dummy_fun <- function(mat) 3 * mat[, "x1"]^2 + 2 * mat[, "x1"] * mat[, "x2"] - 2 * mat[, "x3"]


## ----run_model1----------------------------------------
y <- dummy_fun(mat)
y

quantile(y)
mean(y)
median(y)

## ----plot_uncertainty1, fig.height=5, fig.width=5------

plot_uncertainty(Y = y, N = N) +
  geom_histogram(fill = "grey", color = "black")


plot_uncertainty(Y = y, N = N) +
  geom_histogram(fill = "grey", color = "black") +
  geom_vline(aes(xintercept = mean(y), color = "red")) +
  geom_vline(aes(xintercept = median(y), color = "blue"))
