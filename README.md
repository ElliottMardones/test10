
<!-- README.md is generated from README.Rmd. Please edit that file -->

# test10

<!-- badges: start -->
<!-- badges: end -->

## Description

The \<name.pkg> library extends the theory of forgotten effects for
multiple key informants with complete graphs and chain bipartite graphs.
Provides analysis tools of left one-sided significance for edges,
two-sided significance for nodes, and median betweenness centrality for
first-order matrices.

The package allows for:

-   Calculation of the average incidence by edges for direct effects.
-   Calculation of the average incidence per row and column for direct
    effects.
-   Calculation of the median betweenness centrality per node for direct
    effects.
-   Missing effects calculation with aggregation of multiple key
    informants.
-   Use of complete graphs and chain bipartite graphs.

## Authors

**Elliott Jamil Mardones Arias**  
School of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351  
Temuco, Chile  
<emardones2016@inf.uct.cl>

**Julio Rojas-Mora**  
Department of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351   Temuco, Chile  
and   Centro de Políticas Públicas  
Universidad Católica de Temuco  
Temuco, Chile  
<jrojas@inf.uct.cl>

## Installation

You can install the stable version of \<package.name> from CRAN with:

``` r
# install.packages(“<package.name>”)
```

and the development version from GitHub with:

``` r
#install.packages(“devtools”)
#devtools::install_github("ElliottMardones/<package.name>")
```

## Usage

``` r
library(test10)
```

## 

## Functions

The package provides five functions:

``` r
?directEffects
#> starting httpd help server ... done
```

Calculates mean incidence, left one-sided confidence interval and
p-value with multiple key informants for complete networks and chain
bipartite networks. For more details, see help(de.sq).

``` r
?bootMargin
```

Computes the mean incidence for each cause and each effect, confidence
intervals, and p-value with multiple key informants for complete graphs
and chain bipartite graphs. For more details, see help(bootMargin).

``` r
?centrality
```

Performs the computation of median betweenness centrality with multiple
key informants for complete graphs and chain bipartite graphs. For more
details, see help(centrality).

``` r
?fe.sq
```

It performs the calculation of the forgotten effects proposed by
Kaufmann and Gil-Aluja (1988) with multiple key informants for complete
graphs, with the frequency of appearance of the forgotten effect, mean
incidence, confidence intervals, and standard error. For more details,
see help(fe.sq).

``` r
?fe.rect
```

It performs the calculation of the forgotten effects proposed by
Kaufmann and Gil-Aluja (1988) with multiple key informants for chain
bipartite graphs, with the frequency of appearance of the forgotten
effect, mean incidence, confidence intervals, and standard error. For
more details, see help(fe.rect)

## DataSet

The library provides 3 three-dimensional incidence matrices which are
called `AA`, `AB` and `BB`. The data are those used in the study
“Application of the Forgotten Effects Theory For Assessing the Public
Policy on Air Pollution Of the Commune of Valdivia, Chile” developed by
Manna, E. M et al (2018).

The data consists of 16 incentives, 4 behaviors and 10 key informants,
where each of the key informants presented the data with a minimum and
maximum value for each incident. The description of the data can be seen
in Tables 1 and 2 of Manna, E. M et al (2018).

The library presents the data with the average between the minimum and
maximum value for each incidence. For more details of the data you can
consult:

``` r
help(AA)
help(AB)
help(BB)
```

## Examples

### **directEffects()**

The `directEffects()` function calculates the mean incidence, left
one-sided confidence interval, and p-value with multiple key informants
for complete graphs and chain bipartite graphs.

The function contemplates two modalities, the first is focused on
complete graphs and the second for chain bipartite graphs.

#### For complete graphs

To calculate the significant direct effects of the incidence matrix
`AA`, which is described in DataSet, we use the parameter `CC`, which
allows us to enter a three-dimensional matrix, where each submatrix
along the z-axis is a square incidence matrix and reflective, or a list
of data.frame containing square and reflective incidence matrices. Each
matrix represents a complete graph. The `CE` and `EE` parameters are
used to perform the calculation with chain bipartite graphs, therefore
it is necessary that these parameters are not used.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr` is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

The `directEffects()` function makes use of the `boot.one.bca` function
from the `wBoot` package to perform a z-test, bootstrap, and use the BCa
method. The `conf.level` parameter defines the confidence level and
`reps` the number of bootstrap replicas. By default `conf.level = 0.95`
and `reps = 10000`.

For example, let `thr = 0.5` and `reps = 1000`, we get:

``` r
result <- directEffects(CC = AA, thr = 0.5, reps = 1000)
```

The function returns a list object with the `$DirectEffects` data subset
that contains the following values:

-   From: Origin of the incident
-   To: Destination of the incident
-   Mean: Average incidence
-   UCI: Upper Confidence Interval
-   p.value: the calculated p-value

The results obtained correspond to 240 first-order incidents. Equivalent
to the number of edges minus the incidence on itself of each edge. The
first 6 values are:

``` r
head(result$DirectEffects)
#>   From To  Mean   UCI p.value
#> 1   I1 I2 0.525 0.640   0.574
#> 2   I1 I3 0.450 0.600   0.282
#> 3   I1 I4 0.525 0.665   0.584
#> 4   I1 I5 0.465 0.635   0.376
#> 5   I1 I6 0.645 0.795   0.898
#> 6   I1 I7 0.815 0.875   1.000
```

If any of the occurrences have `"NA"` and `"NaN"` values in the UCI and
p.value fields, it indicates that the values for that occurrence have
repeated values. This prevents bootstrapping.

The `delete` parameter allows assigning zeros to edges whose incidences
are significantly less than `thr` to the p-value set in the `conf.level`
parameter. Also, this allows you to remove non-significant results from
the `$DirectEffects` subset.

For example, let `thr = 0.5` and `conf.level = 0.95`, mean incidences
less than `0.5` or incidents with p.value less than `1 - conf.level`
will be eliminated.

``` r
result <- directEffects(CC = AA, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
```

The function reports by console when significant edges have been
removed. The number of significant direct effects decreased from 240 to
205 for `delete = TRUE`.

**Note:** However, this does not guarantee that a non-significant
variable in 1st order does not generate 2nd order effects, since they
are extracted from the empirical distribution of the key informants.

For `delete = TRUE`, the function returns `$Data`, the three-dimensional
matrix entered in the `CC` parameter but assigning 0 to the
non-significant edges.

For chain bipartite graphs To calculate the significant direct effects
of the incidence matrices `AA`, `AB` and `BB`, which are described in
DataSet, we make use of the already described parameter `CC`. The `EE`
parameter is equivalent to the `CC` parameter. The `CE` parameter allows
you to enter a three-dimensional matrix, where each sub-matrix along the
z-axis is a rectangular incidence matrix or a list of data.frame
containing rectangular incidence matrices. Each matrix represents a
bipartite graph.

For example, let `thr = 0.5` and `reps = 1000`, you get:

``` r
result <- directEffects(CC = AA, CE = AB, EE = BB, reps = 1000)
```

The results obtained correspond to 312 first-order incidents. Using the
`delete = TRUE` parameter, the number of first-order significant
occurrences was reduced to 271.

For `delete = TRUE`, the function returns `$CC`, `$CE`, and `$EE`, which
are the three-dimensional matrices entered in the parameters `CC`, `CE`,
and `EE`, but assigning 0 to the non-significant edges.

#### For chain bipartite graphs

To calculate the significant direct effects of the incidence matrices
`AA`, `AB`and `BB`, which are described in DataSet, we make use of the
already described parameter `CC`. The `EE`parameter is equivalent to the
`CC`parameter. The `CE`parameter allows you to enter a three-dimensional
matrix, where each sub-matrix along the z-axis is a rectangular
incidence matrix, or a list of data.frame containing rectangular
incidence matrices. Each matrix represents a bipartite graph.

For example, let `thr = 0.5` and `reps = 1000`, you get:

``` r
result <- directEffects(CC = AA, CE = AB, EE = BB, thr = 0.5, reps = 1000)
```

The results obtained correspond to 312 first-order incidents. Using the
`delete = TRUE` parameter, the number of first order significant
occurrences was reduced to 271.

For `delete = TRUE`, the function returns `$CC`, `$CE` and `$EE`, which
are the three-dimensional matrices entered in the parameters `CC`,
`CE`and `EE`, but assigning 0 to the non-significant edges.

### bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause
and each effect, confidence intervals, and p-value with multiple experts
for complete graphs and chain bipartite graphs.

The function contemplates two modalities, the first is focused on
complete graphs and the second for chain bipartite graphs.

#### **For complete graphs**

To calculate the average incidence of each cause and each effect of the
`AA` incidence matrix, which is described in DataSet, we use the `CC`
parameter, which allows us to enter a three-dimensional matrix, where
each sub-matrix along the z-axis is a reflexive square incidence matrix
or a list of `data.frame` containing square and reflexive incidence
matrices. Each matrix represents a complete graph. The `CE` and `EE`
parameters are used to perform the calculation with chain bipartite
graphs, therefore it is necessary that these parameters are not used.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr` is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

The `bootMargin()` function makes use of the `boot.one.bca` function
from the `wBoot` package to perform a z-test, apply bootstrapping, and
the BCa method. The `conf.level` parameter defines the confidence level
and `reps` the number of bootstrap replicas. By default
`conf.level = 0.95` and `reps = 10000`.

For example, let `thr = 0.6` and `reps = 1000` we get:

``` r
result <- bootMargin(CC = AA, thr = 0.6, reps = 1000)
```

The function returns a list object with the data subsets `$byRow` and
`$byCol`, each of these subsets of data contains the following values:

-   Var: Variable name
-   Mean: Calculated mean.
-   LCI: Lower Confidence Interval
-   ICU: Upper Confidence Interval
-   p.value: the calculated p-value.

The `bootMargin()` function allows you to analyze by node or by
variable. The results obtained are:

For `$byRow`

``` r
result$byRow
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.5263240 0.4664 0.5877 1.43e-02
#> 2   I2 0.5985460 0.5550 0.6537 9.34e-01
#> 3   I3 0.4267717 0.3631 0.4781 1.33e-04
#> 4   I4 0.4923750 0.3995 0.5387 1.62e-05
#> 5   I5 0.5365167 0.4702 0.6014 5.77e-02
#> 6   I6 0.5538423 0.4817 0.6166 1.84e-01
#> 7   I7 0.5320407 0.4814 0.5834 1.09e-02
#> 8   I8 0.5436480 0.4664 0.6086 1.00e-01
#> 9   I9 0.4615640 0.4019 0.5160 6.58e-04
#> 10 I10 0.4725780 0.3863 0.5423 1.47e-03
#> 11 I11 0.5992047 0.5470 0.6421 8.09e-01
#> 12 I12 0.4546693 0.3887 0.4990 8.52e-05
#> 13 I13 0.5538873 0.4691 0.6407 3.30e-01
#> 14 I14 0.2486867 0.2083 0.2956 1.52e-03
#> 15 I15 0.4430737 0.3943 0.4980 1.58e-03
#> 16 I16 0.5110577 0.4572 0.5668 3.71e-03
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.4823373 0.3523 0.5740 0.009780
#> 2   I2 0.5550003 0.4417 0.6646 0.514000
#> 3   I3 0.4182377 0.3170 0.5249 0.001050
#> 4   I4 0.4685667 0.3538 0.5800 0.022300
#> 5   I5 0.4630030 0.3578 0.5473 0.000244
#> 6   I6 0.5881073 0.4205 0.6672 0.755000
#> 7   I7 0.5574740 0.4534 0.6522 0.386000
#> 8   I8 0.5762943 0.5127 0.6398 0.435000
#> 9   I9 0.4473273 0.3490 0.5563 0.007480
#> 10 I10 0.4680250 0.3625 0.5650 0.010800
#> 11 I11 0.5765310 0.4343 0.6919 0.712000
#> 12 I12 0.4534903 0.3413 0.5709 0.011400
#> 13 I13 0.5618010 0.4763 0.6320 0.326000
#> 14 I14 0.2736207 0.1868 0.3371 0.000187
#> 15 I15 0.4736610 0.3453 0.6008 0.053500
#> 16 I16 0.5928893 0.5149 0.6828 0.857000
```

The function allows eliminating causes and effects whose average
incidence is not significant at the set `thr` parameter. For example,
for `delete = TRUE`, the number of significant variables decreased.

``` r
result <- bootMargin(CC = AA, thr = 0.6, reps = 1000, delete = TRUE)
```

For `$byRow`

``` r
result$byRow
#>    Var      Mean    LCI    UCI  p.value
#> 2   I2 0.6021757 0.5454 0.6544 0.930000
#> 6   I6 0.5542453 0.4750 0.6177 0.160000
#> 7   I7 0.5315227 0.4791 0.5817 0.004610
#> 8   I8 0.5416957 0.4649 0.6087 0.088300
#> 11 I11 0.5968757 0.5523 0.6440 0.904000
#> 13 I13 0.5548707 0.4649 0.6348 0.297000
#> 15 I15 0.4421407 0.3890 0.4987 0.001630
#> 16 I16 0.5114433 0.4533 0.5653 0.000857
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI p.value
#> 2   I2 0.5546147 0.4474 0.6623  0.3990
#> 6   I6 0.5891260 0.4253 0.6700  0.7280
#> 7   I7 0.5588613 0.4305 0.6560  0.4210
#> 8   I8 0.5751740 0.5087 0.6370  0.3680
#> 11 I11 0.5817957 0.4172 0.6873  0.6720
#> 13 I13 0.5629147 0.4751 0.6272  0.2620
#> 15 I15 0.4746340 0.3589 0.6052  0.0609
#> 16 I16 0.5930910 0.5159 0.6855  0.8880
```

For `delete = TRUE`, the function returns`$Data`, the matrix entered in
the `CC`parameter, but with the non-significant rows and columns
removed.

For `plot = TRUE`, the function returns `$plot`, which contains the
graph generated from the subsets `$byRow` and `$byCol`. On the x-axis
are the “Dependence” associated with `$byCol` and on the y-axis the
“Influence” is associated with `$byRow`.

``` r
result <- bootMargin(CC = AA, thr = 0.6, reps = 1000, delete = TRUE, plot = TRUE)
result$plot
```

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />

#### **For chain bipartite graphs**

To calculate the average incidence of each cause and each effect of the
incidence matrices `AA`, `AB`and `BB`, which are described in DataSet,
we make use of the already described parameter `CC`. The `EE`parameter
is equivalent to the `CC`parameter. The `CE`parameter allows you to
enter a three-dimensional matrix, where each sub-matrix along the z-axis
is a rectangular incidence matrix or a list of data.frame containing
rectangular incidence matrices. Each matrix represents a bipartite
graph.

For example, let `thr = 0.5` and `reps = 1000`, you get:

``` r
result <- bootMargin(CC = AA, CE = AB, EE = BB, thr = 0.6, reps = 1000)
```

The results obtained correspond to all the nodes or variables found in
the entered matrices.

The results for `$byRow` and `$byCol` are:

For `$byRow`

``` r
result$byRow
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.5154611 0.4742 0.5666 0.002250
#> 2   I2 0.6294926 0.5769 0.6761 0.280000
#> 3   I3 0.4559297 0.3976 0.5199 0.001720
#> 4   I4 0.5100029 0.4413 0.5703 0.008660
#> 5   I5 0.5467868 0.4907 0.6066 0.088600
#> 6   I6 0.5821671 0.5108 0.6551 0.642000
#> 7   I7 0.5722884 0.5224 0.6361 0.402000
#> 8   I8 0.5715042 0.5063 0.6379 0.402000
#> 9   I9 0.4794995 0.4104 0.5366 0.000619
#> 10 I10 0.5178237 0.4408 0.5887 0.036400
#> 11 I11 0.6558103 0.5984 0.7187 0.062700
#> 12 I12 0.4791576 0.4209 0.5406 0.000944
#> 13 I13 0.6241787 0.5318 0.7195 0.581000
#> 14 I14 0.2442055 0.2026 0.2831 0.000833
#> 15 I15 0.4593621 0.4137 0.5053 0.000830
#> 16 I16 0.5269345 0.4809 0.5725 0.002130
#> 17  B1 0.6787250 0.6000 0.7200 0.201000
#> 18  B2 0.6810850 0.5700 0.7550 0.234000
#> 19  B3 0.6757800 0.5500 0.7717 0.539000
#> 20  B4 0.8082183 0.8000 0.8200 0.000446
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.4801457 0.3582 0.5769 0.005080
#> 2   I2 0.5558087 0.4342 0.6608 0.463000
#> 3   I3 0.4211833 0.3201 0.5155 0.001950
#> 4   I4 0.4686253 0.3602 0.5811 0.022700
#> 5   I5 0.4642970 0.3479 0.5383 0.001280
#> 6   I6 0.5867590 0.4361 0.6710 0.778000
#> 7   I7 0.5554963 0.4438 0.6524 0.402000
#> 8   I8 0.5722903 0.5153 0.6512 0.582000
#> 9   I9 0.4466477 0.3557 0.5503 0.007480
#> 10 I10 0.4661337 0.3658 0.5757 0.019400
#> 11 I11 0.5786163 0.4261 0.6874 0.672000
#> 12 I12 0.4561693 0.3386 0.5668 0.018400
#> 13 I13 0.5620877 0.4776 0.6359 0.319000
#> 14 I14 0.2727383 0.1948 0.3352 0.000253
#> 15 I15 0.4758407 0.3476 0.5897 0.034500
#> 16 I16 0.5924933 0.5143 0.6923 0.891000
#> 17  B1 0.5435055 0.4398 0.6421 0.217000
#> 18  B2 0.6752208 0.6082 0.7541 0.022200
#> 19  B3 0.6882379 0.6355 0.7726 0.000037
#> 20  B4 0.6283447 0.5247 0.7302 0.584000
```

For `delete = TRUE`, the function returns `$CC`, `$CE`, and `$EE`, which
are the three-dimensional arrays entered in the `CC`, `CE`, and `EE`
parameters, but with the rows and columns removed.

For `plot = TRUE`, the function returns `$plot`, which contains the
graph generated from the subsets `$byRow` and `$byCol`. On the x-axis
are the “Dependence” associated with `$byCol` and on the y-axis the
“Influence” is associated with `$byRow`.

### centralitry()

The `centrality()` function calculates the median betweenness
centrality, confidence intervals, and the selected method for
calculating the centrality distribution for complete graphs and chain
bipartite graphs.

The function contemplates two modalities, the first is focused on
complete graphs and the second for chain bipartite graphs.

#### For complete graphs

To calculate the median betweenness centrality of the incidence matrix
`AA`, which is described in DataSet, we use the parameter `CC`, which
allows us to enter a three-dimensional matrix, where each submatrix
along the z-axis is a square incidence matrix and reflective, or a list
of data.frame containing square and reflective incidence matrices. Each
matrix represents a complete graph. The `CE`and `EE`parameters are used
to perform the calculation with chain bipartite graphs, therefore it is
necessary that these parameters are not used.

The `centrality()` function makes use of the `"boot"` function from the
boot package (Canty A, Ripley BD, 2021) to perform a t-test, bootstrap,
and BCa method. The number of bootstrap replicas is defined in the
`reps`parameter. By default `reps = 10000`.

The model parameter allows bootstrapping with some of the following
statistics: mediate.

-   `median`.
-   `conpl`: Calculate the median of a power distribution according to
    Newman M.E (2005).
-   `conlnorm`: Calculates the median of a power distribution according
    to Gillespie CS (2015).

The objective of the model parameter is to determine to which
heavy-tailed distribution the variables or nodes of the entered
parameter correspond.

For example, let `model = "median"` and `reps = 300`, we will obtain:

``` r
result <- centrality(CC = AA, model = "median", reps = 300)
#> Warning in resultBoot_median(output_resultIgraph, parallel, reps, ncpus, :
#> Variable I3 has median = 0
#> Warning in resultBoot_median(output_resultIgraph, parallel, reps, ncpus, :
#> Variable I9 has median = 0
#> Warning in resultBoot_median(output_resultIgraph, parallel, reps, ncpus, :
#> Variable I12 has median = 0
#> Warning in resultBoot_median(output_resultIgraph, parallel, reps, ncpus, :
#> Variable I14 has median = 0
```

The returned object of type data.frame contains the following
components:

-   Var: Name of the variable.
-   Median: Median calculated.
-   LCI: Lower Confidence Interval.
-   ICU: Upper Confidence Interval.
-   Method: Statistical method used associated with the model parameter.

If the median calculated for any of the betweenness centrality has a
median equal to 0, the LCI and UCI fields will have a value equal to 0.
This is reported with a warning per console.

The results are:

``` r
result
#>    Var     Median       LCI       UCI Method
#> 1   I1 13.1666667 0.0000000 22.716667 median
#> 2   I2 12.9875000 1.6919056 24.483674 median
#> 3   I3  0.0000000 0.0000000  0.000000 median
#> 4   I4  0.8333333 0.0000000  2.079167 median
#> 5   I5  6.2083333 0.4958333 10.116262 median
#> 6   I6 20.2791667 2.9847030 36.000000 median
#> 7   I7 11.0833333 1.7500000 33.392388 median
#> 8   I8  4.7083333 0.0000000 10.333333 median
#> 9   I9  0.0000000 0.0000000  0.000000 median
#> 10 I10  1.5000000 0.0000000  6.750000 median
#> 11 I11 15.8333333 3.6666667 30.746733 median
#> 12 I12  0.0000000 0.0000000  0.000000 median
#> 13 I13  4.7916667 0.5000000 10.784982 median
#> 14 I14  0.0000000 0.0000000  0.000000 median
#> 15 I15  2.5000000 0.0000000  8.583333 median
#> 16 I16 13.1666667 4.4051587 38.958333 median
```

Now if we use `"conpl"` in the model parameter and 300 bootstrap
replicas, we get:

``` r
result <- centrality(CC = AA, model = "conpl", reps = 300)
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I3 has median = 0
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I9 has median = 0
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I12 has median = 0
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I14 has median = 0
result
#>    Var     Median       LCI       UCI Method
#> 1   I1 13.1666667 0.0000000 23.370123 median
#> 2   I2 12.9875000 1.5493894 24.125000 median
#> 3   I3  0.0000000 0.0000000  0.000000 median
#> 4   I4  0.8333333 0.0000000  1.995833 median
#> 5   I5  6.2083333 0.4958333 10.000000 median
#> 6   I6 20.2791667 4.5607143 42.583333 median
#> 7   I7 11.0833333 1.7500000 41.000000 median
#> 8   I8  4.7083333 0.1000000 10.442321 median
#> 9   I9  0.0000000 0.0000000  0.000000 median
#> 10 I10  1.5000000 0.0000000  8.125000 median
#> 11 I11 15.8333333 2.6250000 30.416667 median
#> 12 I12  0.0000000 0.0000000  0.000000 median
#> 13 I13  4.7916667 0.8448436  9.916667 median
#> 14 I14  0.0000000 0.0000000  0.000000 median
#> 15 I15  2.5000000 0.0000000 14.354167 median
#> 16 I16 13.1666667 2.5833333 23.479167 median
```

**Note:** If the calculation cannot be performed with `model = "conpl"`
in some node, the function will perform the calculation with `"median"`.
This change is indicated in the Method field.

Now if we use `"conlnorm"` in the model parameter and 300 bootstrap
replicas, we get:

``` r
result <- centrality(CC = AA, model = "conlnorm", reps = 300)
#> Warning in conlnorm_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I3 has median = 0
#> Warning in conlnorm_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I9 has median = 0
#> Warning in conlnorm_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I12 has median = 0
#> Warning in conlnorm_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I14 has median = 0
result
#>    Var     Median      LCI       UCI Method
#> 1   I1 13.1666667 0.000000 21.358333 median
#> 2   I2 12.9875000 2.250000 25.166667 median
#> 3   I3  0.0000000 0.000000  0.000000 median
#> 4   I4  0.8333333 0.000000  3.158333 median
#> 5   I5  6.2083333 0.662500 10.294139 median
#> 6   I6 20.2791667 4.560714 42.583333 median
#> 7   I7 11.0833333 2.000000 41.000000 median
#> 8   I8  4.7083333 0.200000 10.833333 median
#> 9   I9  0.0000000 0.000000  0.000000 median
#> 10 I10  1.5000000 0.000000  8.125000 median
#> 11 I11 15.8333333 3.666667 30.416667 median
#> 12 I12  0.0000000 0.000000  0.000000 median
#> 13 I13  4.7916667 0.500000  9.916667 median
#> 14 I14  0.0000000 0.000000  0.000000 median
#> 15 I15  2.5000000 0.000000  8.583333 median
#> 16 I16 13.1666667 1.719253 28.458333 median
```

**Note:** If the calculation cannot be performed with
`model = "conlnorm"` in some node, the function will perform the
calculation with “median”. This change is indicated in the Method field

**IMPORTANT:** The best statistic to use in the model parameter will
depend on the data and the number of bootstrap replicas that you deem
appropriate.

The `centrality()` function implements the parallel function from the
boot package. The `parallel`parameter allows you to set the type of
parallel operation that is required. The options are `"multicore"`,
`"snow"` and `"no"`. By default `parallel = "no"`. The number of
processors to be used in the paralell implementation is defined in the
`ncpus`parameter. By default `ncpus = 1`.

The `parallel`and `ncpus`options are not available on Windows operating
systems.

**For chain bipartite graphs**

To calculate the median betweenness centrality of the incidence matrices
`AA`, `AB`and `BB`, which are described in DataSet, we make use of the
already described parameter `CC`. The `EE`parameter is equivalent to the
`CC`parameter. The `CE`parameter allows you to enter a three-dimensional
matrix, where each sub-matrix along the z-axis is a rectangular
incidence matrix, or a list of data.frame containing rectangular
incidence matrices. Each matrix represents a bipartite graph.

For example, let `model = "conpl"` and `reps = 300`, you get:

``` r
result <- centrality(CC = AA, CE = AB, EE = BB, model = "conpl", reps = 300)
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I3 has median = 0
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable I14 has median = 0
#> Warning in conpl_function(resultCent = output_resultIgraph, parallel =
#> parallel, : Variable B1 has median = 0
result
#>    Var     Median        LCI       UCI Method
#> 1   I1 14.0416667  0.0000000 35.000000 median
#> 2   I2 14.6913273 10.1946668 17.240026  conpl
#> 3   I3  0.0000000  0.0000000  0.000000 median
#> 4   I4  0.9166667  0.1666667 14.479167 median
#> 5   I5  6.2083333  0.6625000 12.109849 median
#> 6   I6 24.6720238  4.7778998 60.916667 median
#> 7   I7  9.2552918  1.1287511 24.966578  conpl
#> 8   I8  8.2761905  3.7500000 15.000000 median
#> 9   I9  0.3750000  0.0000000  3.650000 median
#> 10 I10  1.5714286  0.3083333  8.125000 median
#> 11 I11 21.0241962 17.1725831 21.499852  conpl
#> 12 I12  3.3333333  0.0000000 12.516667 median
#> 13 I13  5.0166667  0.9930742 14.416667 median
#> 14 I14  0.0000000  0.0000000  0.000000 median
#> 15 I15  2.5000000  0.0000000  9.166667 median
#> 16 I16 18.7916667  2.5833333 34.294048 median
#> 17  B1  0.0000000  0.0000000  0.000000 median
#> 18  B2  2.7833333  1.0000000  7.100000 median
#> 19  B3  2.0000000  0.2500000  3.196429 median
#> 20  B4  1.8666667  0.0000000  7.200000 median
```

The `centrality()` function implements the parallel function from the
`boot`package. The `parallel`parameter allows you to set the type of
parallel operation that is required. The options are `"multicore"`,
`"snow"` and `"no"`. By default `parallel = "no"`. The number of
processors to be used in the `paralell`implementation is defined in the
`ncpus`parameter. By default `ncpus = 1`.

The `parallel`and `ncpus`options are not available on Windows operating
systems.

### fe.sq()

The function `fe.sq()`, calculates the forgotten effects (Kaufmann & Gil
Aluja, 1988) with multiple experts for complete graphs, with calculation
of the frequency of appearance of the forgotten effects, mean incidence,
confidence intervals and standard error

For example, to perform the calculation using the incidence matrix `AA`,
described in DATASET, we use the parameter `CC`, which allows us to
enter a three-dimensional matrix, where each sub-matrix along the z axis
is a square and reflective incidence matrix , or a list of data.frame
containing square and reflective incidence matrices. Each matrix
represents a complete graph.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr`is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

To define the maximum order of the forgotten effects, use the
`maxOrder`parameter. By default `maxOrder = 2`.

The `fe.sq()` function uses the `"boot"` function from the boot package
(Canty A, Ripley BD, 2021) to perform a t-test and bootstrap. The number
of bootstrap replicas is defined in the `reps` parameter. By default
`reps = 10000`.

For example, let `thr = 0.5`, `maxOrder = 3` and `reps = 1000`, you get:

``` r
result <- fe.sq(CC = AA, thr = 0.5, maxOrder = 3, reps = 1000)
```

The returned object of type list contains two subsets of data. The
`$boot` data subset is a list of data.frame where each data.frame
represents the order of the calculated forgotten effect, the components
are:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Mean: Mean effect of the forgotten effect
-   LCI: Lower Confidence Intervals.
-   UCI: Upper Confidence Intervals.
-   SE: Standard error.

The `$byExperts` data subset is a list of `data.frame` where each
`data.frame` represents the order of the forgotten effect calculated
with its associated incidence value for each expert, the components are:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Expert_x: Dynamic field that represents each of the entered experts.
-   

If we look at the data in the `$boot$Order_2` data subset, we find 706
2nd order effects and 611 of these effects are unique. The first 6 are:

``` r
head(result$boot$Order_2)
#>   From Through_1  To Count      Mean    LCI       UCI         SE
#> 1   I8       I11 I10     4 0.6125000 0.5625 0.6625000 0.02689207
#> 2   I5       I11 I10     3 0.6166667 0.5500 0.6666667 0.03590382
#> 3   I6       I11 I14     3 0.6833333 0.6000 0.7666667 0.06875200
#> 4  I13       I11 I14     3 0.5833333 0.5500 0.6000000 0.01367935
#> 5  I13        I6  I1     3 0.6333333 0.6000 0.6666667 0.02781541
#> 6  I13       I16  I1     3 0.6333333 0.6000 0.6666667 0.02745610
```

The relations I8 -> I11 -> I10 appeared 4 times. To know exactly in
which expert these relationships were found, there is the `$byExperts`
data subset. If we look at the first row of `$byExperts$order_2` we can
identify the experts who provided this information.

``` r
head(result$byExperts$Order_2)
#>   From Through_1  To Count Expert_1 Expert_2 Expert_3 Expert_4 Expert_5
#> 1   I8       I11 I10     4     0.55      0.6     0.00      0.6      0.0
#> 2   I5       I11 I10     3     0.55      0.7     0.00      0.0      0.0
#> 3   I6       I11 I14     3     0.00      0.6     0.85      0.6      0.0
#> 4  I13       I11 I14     3     0.00      0.6     0.00      0.6      0.0
#> 5  I13        I6  I1     3     0.00      0.0     0.60      0.6      0.0
#> 6  I13       I16  I1     3     0.00      0.0     0.00      0.6      0.7
#>   Expert_6 Expert_7 Expert_8 Expert_9 Expert_10
#> 1      0.7     0.00      0.0        0       0.0
#> 2      0.0     0.00      0.6        0       0.0
#> 3      0.0     0.00      0.0        0       0.0
#> 4      0.0     0.55      0.0        0       0.0
#> 5      0.0     0.00      0.0        0       0.7
#> 6      0.0     0.00      0.6        0       0.0
```

**IMPORTANT**: If any of the `$boot` values shows `"NA"` in LCI, UCI and
SE, it indicates that the values of the incidents per expert are the
same or the value is unique. That prevents implementing bootstrap.

The `fe.sq()` function implements the parallel function from the boot
package. The parallel parameter allows you to set the type of parallel
operation that is required. The options are `"multicore"`, `"snow"` and
`"no"`. By default `parallel = "no"`. The number of processors to be
used in the `paralell`implementation is defined in the `ncpus`parameter.
By default `ncpus = 1`.

The `parallel` and `ncpus`options are not available on Windows operating
systems.

### fe.rect()

The function `fe.rect()`, calculates the forgotten effects (Kaufmann &
Gil Aluja, 1988) with multiple key informants for chain bipartite
graphs, with calculation of the frequency of appearance of the forgotten
effects, mean incidence, confidence intervals and standard error.

To perform the calculation using the incidence matrices `AA`, `AB`and
`BB`, which are described in DataSet, we make use of the already
described parameter `CC`. The `EE` parameter is equivalent to the `CC`
parameter. The `CE` parameter allows you to enter a three-dimensional
matrix, where each sub-matrix along the z-axis is a rectangular
incidence matrix, or a list of data.frame containing rectangular
incidence matrices. Each matrix represents a bipartite graph.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr` is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

To define the maximum order of the forgotten effects, use the
`maxOrder`parameter. By default `maxOrder = 2`.

The `fe.rect()` function makes use of the `"boot"` function from the
`boot` package (Canty A, Ripley BD, 2021) to perform a t-test and
bootstrap. The number of bootstrap replicas is defined in the `reps`
parameter. By default `reps = 10000`.

For example, let `thr = 0.5`, `maxOrder = 3` and `reps = 1000`, you get:

``` r
result <- fe.rect(CC = AA,CE = AB, EE = BB, thr = 0.5, maxOrder = 3, reps = 1000)
#> Warning in wrapper.indirectEffects_R(CC = CC, CE = CE, EE = EE, thr = thr, :
#> Expert number 7 has no 2nd maxOrder or higher effects.
```

The returned object of type list contains two subsets of data. The
`$boot` data subset is a list of data.frame where each data.frame
represents the order of the calculated forgotten effect, the components
are:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Mean: Mean effect of the forgotten effect
-   LCI: Lower Confidence Intervals.
-   UCI: Upper Confidence Intervals.
-   SE: Standard error.

The `$byExperts` data subset is a list of `data.frame` where each
`data.frame` represents the order of the forgotten effect calculated
with its associated incidence value for each expert, the components are:

-   From: Indicates the origin of the forgotten effects relationships.

-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1>”.

-   To: Indicates the end of the forgotten effects relationships.

-   Count: Number of times the forgotten effect was repeated.

-   Expert_x: Dynamic field that represents each of the entered experts.

If we look at the data in the `$boot$Order_2` data subset, we find 182
2nd order effects and 162 of these effects are unique. The first 6 are:

``` r
head(result$boot$Order_2)
#>   From Through_1 To Count      Mean  LCI       UCI         SE
#> 1   I5        B4 B1     3 0.6333333 0.60 0.6666667 0.02754025
#> 2   I6        I7 B1     2 0.8000000 0.75 0.8000000 0.03489434
#> 3   I8        I7 B1     2 0.6250000 0.60 0.6250000 0.01772889
#> 4  I12        I2 B1     2 0.7000000 0.65 0.7000000 0.03425322
#> 5  I10       I11 B2     2 0.5750000 0.55 0.6000000 0.01803567
#> 6  I14       I15 B2     2 0.7250000 0.70 0.7250000 0.01764090
```

The relations I5 -> B4 -> B1 appeared 3 times. To know exactly in which
expert these relationships were found, there is the `$byExperts` data
subset. If we look at the first row of `$byExperts$order_2` we can
identify the experts who provided this information.

``` r
head(result$byExperts$Order_2)
#>   From Through_1 To Count Expert_1 Expert_2 Expert_3 Expert_4 Expert_5 Expert_6
#> 1   I5        B4 B1     3     0.60      0.7        0     0.60     0.00        0
#> 2   I6        I7 B1     2     0.75      0.0        0     0.85     0.00        0
#> 3   I8        I7 B1     2     0.65      0.6        0     0.00     0.00        0
#> 4  I12        I2 B1     2     0.65      0.0        0     0.75     0.00        0
#> 5  I10       I11 B2     2     0.60      0.0        0     0.00     0.55        0
#> 6  I14       I15 B2     2     0.75      0.0        0     0.00     0.70        0
#>   Expert_7 Expert_8 Expert_9 Expert_10
#> 1        0        0        0         0
#> 2        0        0        0         0
#> 3        0        0        0         0
#> 4        0        0        0         0
#> 5        0        0        0         0
#> 6        0        0        0         0
```

**MPORTANT:** If any of the `$boot` values shows `"NA"` in LCI, UCI and
SE, it indicates that the values of the incidents per expert are the
same or the value is unique. That prevents implementing bootstrap.

The `fe.sq()` function implements the parallel function from the boot
package. The `parallel`parameter allows you to set the type of parallel
operation that is required. The options are `"multicore"`, `"snow"` and
`"no"`. By default `parallel = "no"`. The number of processors to be
used in the `paralell` implementation is defined in the `ncpus`
parameter. By default `ncpus = 1`.

The `parallel` and `ncpus` options are not available on Windows
operating systems.

## References

1.  Kaufmann, A., & Gil Aluja, J. (1988). Modelos para la Investigación
    de efectos olvidados, Milladoiro. Santiago de Compostela, España.

2.  Manna, E. M., Rojas-Mora, J., & Mondaca-Marino, C. (2018).
    Application of the Forgotten Effects Theory for Assessing the Public
    Policy on Air Pollution of the Commune of Valdivia, Chile. In From
    Science to Society (pp. 61-72). Springer, Cham.

3.  Freeman, L.C. (1979). Centrality in Social Networks I: Conceptual
    Clarification. Social Networks, 1, 215-239.

4.  Ulrik Brandes, A Faster Algorithm for Betweenness Centrality.
    Journal of Mathematical Sociology 25(2):163-177, 2001.

5.  Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R
    package version 1.3-28.

6.  Davison AC, Hinkley DV (1997). Bootstrap Methods and Their
    Applications. Cambridge University Press, Cambridge. ISBN
    0-521-57391-2, <http://statwww.epfl.ch/davison/BMA/>.

7.  Newman, M. E. (2005). Power laws, Pareto distributions and Zipf’s
    law. Contemporary physics, 46(5), 323-351.

8.  Gillespie, C. S. (2014). Fitting heavy tailed distributions: the
    poweRlaw package. arXiv preprint arXiv:1407.3492.

9.  <https://cran.r-project.org/web/packages/wBoot/index.html>
