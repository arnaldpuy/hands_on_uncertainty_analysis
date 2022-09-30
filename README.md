
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Install and load required packages

You should have the packages `sensobol` [@puy2022a], `data.table`
\[@Dowle2020\] and `tidyverse` \[@wickham2019\] installed in your R
environment to reproduce the results of this session. To install them,
remove the hash character from the first line of the code snippet below
and run the code.

``` r

# install.packages(c("sensobol", "data.table", "tidyverse"))

library("sensobol")
library("data.table")
library("tidyverse")
```

# Uncertainty analysis

An uncertainty analysis (UA) aims at quantifying how the uncertainty in
the model inputs (e.g., in parameters, boundary conditions, mathematical
formulations) affect the model output. Uncertainty can derive from
measurement error, natural variation, inherent randomness or lack of
knowledge (epistemic uncertainty). Often an uncertainty analysis goes
alongside a sensitivity analysis (SA), which aims at informing which
inputs convey the most uncertainty to the output \[@saltelli2008\]. Both
UA/SA increase the transparency and quality of the modelling process and
are especially recommended if the model aims at guiding decisions in the
real world \[@saltelli2020a\].

An uncertainty analysis requires the analyst to:

- Define which inputs of the model are treated as uncertain.

- Design a sample matrix. This sample matrix will reflect your model’s
  uncertain space and will be formed by $N$ rows and $k$ columns. $N$ is
  a number chosen by the analyst (often $N > 10,000$) and reflects the
  sample size, the number of times that the model will ran on different
  combination of values for the uncertain inputs, and $k$ reflects the
  number of uncertain inputs.

- Run the model throughout the sample matrix in order to get a vector
  with the model output.

- Describe the uncertainty in the output with descriptive statistics
  (average value, median, quantiles, confidence intervals, etc) and
  appropriate plots.

Here we will show how to conduct an UA/SA analysis in the R environment.
First, we define the main settings of the UA, which will remain the same
throughout the exercise unless stated otherwise. We define the sample
size as $N=2^7=128$, the required matrix as “A” (we will see later on
what does this mean) and the type of sample matrix as “QRN”, meaning
that we will use quasi-random numbers to build the sample matrix (we
will see why later on).

``` r

# MAIN SETTINGS ###############################################################

# Sample size
N <- 2^7

# Required matrices
matrices <- "A"

# Type of sample matrix
type <- "QRN"
```

Now let us get into the meat of the matter.

## Dummy example (1)

Let us start by assuming that our model has two uncertain inputs, which
we will name $x_1$ and $x_2$:

``` r
params <- c("x1", "x2")
```

We then create the sample matrix with the function `sobol_matrices`,
from the `sensobol` package \[@puy2022a\].

``` r
mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)
```

Let us inspect the resulting matrix: first, we print the matrix, and
then we plot it:

``` r
mat
#>                x1        x2
#>   [1,] 0.50000000 0.5000000
#>   [2,] 0.75000000 0.2500000
#>   [3,] 0.25000000 0.7500000
#>   [4,] 0.37500000 0.3750000
#>   [5,] 0.87500000 0.8750000
#>   [6,] 0.62500000 0.1250000
#>   [7,] 0.12500000 0.6250000
#>   [8,] 0.18750000 0.3125000
#>   [9,] 0.68750000 0.8125000
#>  [10,] 0.93750000 0.0625000
#>  [11,] 0.43750000 0.5625000
#>  [12,] 0.31250000 0.1875000
#>  [13,] 0.81250000 0.6875000
#>  [14,] 0.56250000 0.4375000
#>  [15,] 0.06250000 0.9375000
#>  [16,] 0.09375000 0.4687500
#>  [17,] 0.59375000 0.9687500
#>  [18,] 0.84375000 0.2187500
#>  [19,] 0.34375000 0.7187500
#>  [20,] 0.46875000 0.0937500
#>  [21,] 0.96875000 0.5937500
#>  [22,] 0.71875000 0.3437500
#>  [23,] 0.21875000 0.8437500
#>  [24,] 0.15625000 0.1562500
#>  [25,] 0.65625000 0.6562500
#>  [26,] 0.90625000 0.4062500
#>  [27,] 0.40625000 0.9062500
#>  [28,] 0.28125000 0.2812500
#>  [29,] 0.78125000 0.7812500
#>  [30,] 0.53125000 0.0312500
#>  [31,] 0.03125000 0.5312500
#>  [32,] 0.04687500 0.2656250
#>  [33,] 0.54687500 0.7656250
#>  [34,] 0.79687500 0.0156250
#>  [35,] 0.29687500 0.5156250
#>  [36,] 0.42187500 0.1406250
#>  [37,] 0.92187500 0.6406250
#>  [38,] 0.67187500 0.3906250
#>  [39,] 0.17187500 0.8906250
#>  [40,] 0.23437500 0.0781250
#>  [41,] 0.73437500 0.5781250
#>  [42,] 0.98437500 0.3281250
#>  [43,] 0.48437500 0.8281250
#>  [44,] 0.35937500 0.4531250
#>  [45,] 0.85937500 0.9531250
#>  [46,] 0.60937500 0.2031250
#>  [47,] 0.10937500 0.7031250
#>  [48,] 0.07812500 0.2343750
#>  [49,] 0.57812500 0.7343750
#>  [50,] 0.82812500 0.4843750
#>  [51,] 0.32812500 0.9843750
#>  [52,] 0.45312500 0.3593750
#>  [53,] 0.95312500 0.8593750
#>  [54,] 0.70312500 0.1093750
#>  [55,] 0.20312500 0.6093750
#>  [56,] 0.14062500 0.4218750
#>  [57,] 0.64062500 0.9218750
#>  [58,] 0.89062500 0.1718750
#>  [59,] 0.39062500 0.6718750
#>  [60,] 0.26562500 0.0468750
#>  [61,] 0.76562500 0.5468750
#>  [62,] 0.51562500 0.2968750
#>  [63,] 0.01562500 0.7968750
#>  [64,] 0.02343750 0.3984375
#>  [65,] 0.52343750 0.8984375
#>  [66,] 0.77343750 0.1484375
#>  [67,] 0.27343750 0.6484375
#>  [68,] 0.39843750 0.0234375
#>  [69,] 0.89843750 0.5234375
#>  [70,] 0.64843750 0.2734375
#>  [71,] 0.14843750 0.7734375
#>  [72,] 0.21093750 0.2109375
#>  [73,] 0.71093750 0.7109375
#>  [74,] 0.96093750 0.4609375
#>  [75,] 0.46093750 0.9609375
#>  [76,] 0.33593750 0.3359375
#>  [77,] 0.83593750 0.8359375
#>  [78,] 0.58593750 0.0859375
#>  [79,] 0.08593750 0.5859375
#>  [80,] 0.11718750 0.1171875
#>  [81,] 0.61718750 0.6171875
#>  [82,] 0.86718750 0.3671875
#>  [83,] 0.36718750 0.8671875
#>  [84,] 0.49218750 0.4921875
#>  [85,] 0.99218750 0.9921875
#>  [86,] 0.74218750 0.2421875
#>  [87,] 0.24218750 0.7421875
#>  [88,] 0.17968750 0.3046875
#>  [89,] 0.67968750 0.8046875
#>  [90,] 0.92968750 0.0546875
#>  [91,] 0.42968750 0.5546875
#>  [92,] 0.30468750 0.1796875
#>  [93,] 0.80468750 0.6796875
#>  [94,] 0.55468750 0.4296875
#>  [95,] 0.05468750 0.9296875
#>  [96,] 0.03906250 0.1328125
#>  [97,] 0.53906250 0.6328125
#>  [98,] 0.78906250 0.3828125
#>  [99,] 0.28906250 0.8828125
#> [100,] 0.41406250 0.2578125
#> [101,] 0.91406250 0.7578125
#> [102,] 0.66406250 0.0078125
#> [103,] 0.16406250 0.5078125
#> [104,] 0.22656250 0.4453125
#> [105,] 0.72656250 0.9453125
#> [106,] 0.97656250 0.1953125
#> [107,] 0.47656250 0.6953125
#> [108,] 0.35156250 0.0703125
#> [109,] 0.85156250 0.5703125
#> [110,] 0.60156250 0.3203125
#> [111,] 0.10156250 0.8203125
#> [112,] 0.07031250 0.3515625
#> [113,] 0.57031250 0.8515625
#> [114,] 0.82031250 0.1015625
#> [115,] 0.32031250 0.6015625
#> [116,] 0.44531250 0.2265625
#> [117,] 0.94531250 0.7265625
#> [118,] 0.69531250 0.4765625
#> [119,] 0.19531250 0.9765625
#> [120,] 0.13281250 0.0390625
#> [121,] 0.63281250 0.5390625
#> [122,] 0.88281250 0.2890625
#> [123,] 0.38281250 0.7890625
#> [124,] 0.25781250 0.4140625
#> [125,] 0.75781250 0.9140625
#> [126,] 0.50781250 0.1640625
#> [127,] 0.00781250 0.6640625
#> [128,] 0.01171875 0.3320312
plot(mat[, "x1"], mat[, "x2"])
```

![](README_files/figure-gfm/inspect_matrix-1.png)<!-- -->

Each row in the matrix just printed corresponds to a point in the plot.
There are 128 rows, so we have 128 points. These points are your
sampling points in the model’s uncertain space, and can be thought of as
coordinates. If you have a look at the first row of the matrix printed
above, you will see that $x_1=x_2=0.5$: this means that the model will
compute the output in that row by assuming that $x_1=x_2=0.5$. In the
second row, the model will assume that $x_1=0.75$ and $x_2=0.25$, and so
on until the 128th row.

In this example we can graphically represent the model’s uncertain space
with a plane because our model has two dimensions and therefore is a
two-dimensional model. The $x-$ and the $y$-axis in the plot represent
the first and the second columns of the sample matrix. When dealing with
$k$-dimensional models, where $k>3$, a graphical representation of the
model’s uncertain space like the one above is not possible because we
live in a three-dimensional world!.

We have built this sample matrix using Quasi-Random Numbers (QRN). But
how does the sample matrix look like if we use another sampling method?
Let us compare QRN with Latin Hypercube Sampling (LHS) and random
numbers (R).

First, we define a vector with the three different sampling methods
available in `sensobol`.

``` r
all_types <- c("QRN", "LHS", "R")
```

We then loop over all these methods to create a matrix for each sampling
method. The we name the slots and plot the resulting matrices for a
better visualization. The code is the following:

``` r

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
```

![](README_files/figure-gfm/plot_sampling_types-1.png)<!-- -->

Which differences do you see between the sampling space created by LHS,
QRN and R?

<div class="alert alert-info">

<strong>Take-home information: </strong> QRN is the preferred sampling
method in uncertainty and sensitivity analysis because it leaves smaller
unexplored volumes and hence maps more effectively the uncertain space.
However, note that random methods might be better to compute sensitivity
indices when the model under examination has important high-order terms
\[@kucherenko2011\]. We will explore sensitivity analysis later on.

</div>

## Dummy example (2)

In this example we will use a very simple model with three uncertain
parameters. Let us first name our parameters $x_1$, $x_2$ and $x_3$:

``` r

params <- c("x1", "x2", "x3")
```

And create again the sample matrix with the function `sobol_matrices`
from the `sensobol` package:

``` r

mat <- sobol_matrices(matrices = matrices, N = N, params = params, type = type)
```

We now define the model. We will use a very simple polynomial:

$$y = 3x_1^2 + 2x_1x_2 -2x_3$$ In the next code snippet we code the
polynomial in a function, which we label `dummy_fun`. Note that the
function needs to be coded as to run rowwise throughout the sample
matrix.

``` r

dummy_fun <- function(mat) 3 * mat[, "x1"]^2 + 2 * mat[, "x1"] * mat[, "x2"] - 2 * mat[, "x3"]
```

We execute the model in the sample matrix and print the output.

``` r
y <- dummy_fun(mat)
y
#>   [1]  0.25000000  0.56250000  0.06250000 -0.54687500  3.57812500  0.57812500
#>   [7] -1.54687500 -0.40234375  0.91015625  1.62890625  0.94140625 -1.46484375
#>  [13]  2.22265625  1.06640625 -1.24609375 -1.57324219  1.52050781  2.31738281
#>  [19] -0.33886719 -0.19042969  2.02832031  0.60644531  0.07519531 -0.94042969
#>  [25]  2.09082031  2.63769531 -0.33105469  0.08300781  1.73925781 -0.93261719
#>  [31] -0.77636719 -1.18725586  1.51586914  1.21118164 -1.14819336  0.18383789
#>  [37]  2.26196289 -0.08959961 -0.57397461 -1.39233398  1.87329102  3.45922852
#>  [43]  0.41235352 -0.13061523  2.01000977  0.01782227 -0.15405273 -0.47631836
#>  [49]  0.32055664  1.82836914  0.93774414 -0.83959961  3.58227539  1.35571289
#>  [55] -0.90991211  0.02172852  1.25610352  1.02954102  0.32641602 -1.16967773
#>  [61]  2.18969727  0.19750977 -1.88061523 -0.87030029 -0.12811279  0.63360596
#>  [67]  0.18829346 -1.14569092  2.72149658  1.47540283 -0.84490967 -0.04315186
#>  [73]  1.26153564  1.89044189  0.75762939 -0.45135498  3.47833252  0.61505127
#>  [79] -1.39276123 -1.25946045  1.57647705  2.06475830 -0.78680420  1.13311768
#>  [85]  3.84405518  0.43389893 -0.04266357 -1.74676514  1.52667236  2.24151611
#>  [91] -0.42254639 -0.31512451  1.33331299  0.19659424 -0.09246826 -1.84442139
#>  [97]  0.69464111  2.11260986 -0.59832764  0.11846924  2.28253174  0.22393799
#> [103]  0.13800049 -1.12860107  2.47296143  2.25811768 -0.64031982  0.18585205
#> [109]  1.91241455 -0.26336670 -0.53680420 -0.35760498  0.52520752  0.26348877
#> [115] -0.22869873 -0.37518311  3.88262939  1.44122314 -1.17596436 -0.73358154
#> [121]  0.08673096  1.55157471  0.74688721 -1.13397217  2.56134033  0.89337158
#> [127] -1.03631592 -1.56211853
```

As you can see, the model output is a vector whose length equals the
number of rows of the sample matrix, 128 in this case. Each element in
the vector shows the output of the model after taking in specific
combinations of $x_1$, $x_2$ and $x_3$ values.

With this vector we can conduct a proper uncertainty analysis of the
model output. We can first visualize the distribution of the output with
an histogram. This is easy to do with the `plot_uncertainty` function of
the `sensobol` package:

``` r

plot_uncertainty(Y = y, N = N) + 
  geom_histogram(fill = "grey", color = "black") # This last line of code is just to fill the histogram with grey colour
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
#> `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](README_files/figure-gfm/plot_uncertainty1-1.png)<!-- -->

Once we get an idea of the shape of the distribution, we can compute
some statistical measures to describe the data. Which descriptive
statistics will you select in this case?

<div class="alert alert-danger">

<strong>Take-home information: </strong> When the output distribution is
not normal (i.e., when it is not Gaussian, not symmetric around the
mean; in other words, when the distribution does not look like a “bell
curve”), the mean or the standard deviation may not be the most
appropriate measures of central tendency and spread. Other options, such
as the median, quartiles, the interquartile range (the difference
between the 75th and the 25th quartile), may be better suited. Always
plot your data to see how it is distributed.

</div>

# References
