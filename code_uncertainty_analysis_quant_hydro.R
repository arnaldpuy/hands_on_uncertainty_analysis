## ----setup, include=FALSE-------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- results="hide", message=FALSE, warning=FALSE------

# install.packages(c("sensobol", "data.table", "tidyverse"))

library("sensobol")
library("data.table")
library("tidyverse")



## ----main_settings--------------------------------------

# Sample size
N <- 2^7

# Required matrices
matrices <- "A"

# Type of sample matrix
type <- "QRN"



## ----params---------------------------------------------
params <- c("x1", "x2")


## ----sobol_matrix, dependson="main_settings"------------
mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)


## ---- inspect_matrix, dependson="sobol_matrix"----------
mat
plot(mat[, "x1"], mat[, "x2"])



## ----sampling_types, dependson="main_settings"----------
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



## ----params2--------------------------------------------

params <- c("x1", "x2", "x3")


## ----sobol_matrix2, dependson="main_settings"-----------

mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)


## ----model----------------------------------------------

dummy_fun <- function(mat) 3 * mat[, "x1"]^2 + 2 * mat[, "x1"] * mat[, "x2"] - 2 * mat[, "x3"]


## ----run_model1-----------------------------------------
y <- dummy_fun(mat)
y


## ----plot_uncertainty1, fig.height=5, fig.width=5-------

plot_uncertainty(Y = y, N = N) +
  geom_histogram(fill = "grey", color = "black") # This last line of code is just to fill the histogram with grey colour



## ----desc_stats-----------------------------------------
mean(y)
median(y)
IQR(y)
quantile(y)



## ----setting2-------------------------------------------

# Sample size
N <- 2^12

# Required matrices
matrices <- c("A", "B", "AB")

# Type of sample matrix
type <- "QRN"

# Bootstrap
boot <- TRUE

# Number of bootstrap samples
R <- 10^3


## ----params3--------------------------------------------
params <- c("A", "ET_c", "P", "E")


## ----sobol_matrix3, dependson="main_settings"-----------
mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)


## ---- inspect_matrix3, dependson="sobol_matrix"---------
head(mat)


## ----quantile-------------------------------------------

mat[, "A"] <- qunif(mat[, "A"], min = 15, max = 20) # for a uniform distribution.
mat[, "ET_c"] <- qnorm(mat[, "ET_c"], mean = 0.4, sd = 0.05) # for a normal distribution.
mat[, "P"] <- qunif(mat[, "P"], min = 0, max = 0.1)
mat[, "E"] <- qunif(mat[, "E"], min = 0.4, max = 0.6)



## ----inspect4-------------------------------------------

head(mat)

irrigation_fun <- function(mat) (mat[, "A"] * (mat[, "ET_c"] - mat[, "P"])) / mat[, "E"]

y <- irrigation_fun(mat)

plot_uncertainty(N = N, Y = y)
plot_scatter(data = mat, N = N, Y = y, params = params)
ind <- sobol_indices(matrices = matrices, Y = y, N = N, params = params,
                     boot = boot, R = R, first = "jansen")
plot(ind)
ind

f <- c(min, max, mean, median)
sapply(f, function(f) f(y))
