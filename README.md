
<!-- README.md is generated from README.Rmd. Please edit that file -->

# test10

<!-- badges: start -->
<!-- badges: end -->

## Description

The foRgotten library extends the theory of forgotten effects with the
aggregation of multiple key informants for complete graphs and chained
bipartite graphs. Provides analysis tools for direct effects and
forgotten effects.

The package allows for:

-   Calculation of the average incidence by edges for direct effects.
-   Calculation of the average incidence per row and column for direct
    effects.
-   Calculation of the median betweenness centrality per node for direct
    effects.
-   Calculation of the forgotten effects.
-   Use of complete graphs and chained bipartite graphs.

## Authors

**Elliott Jamil Mardones Arias**  
School of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351  
Temuco, Chile  
<emardones2016@inf.uct.cl>

**Julio Rojas-Mora** Department of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351 Temuco, Chile  
and Centro de Políticas Públicas  
Universidad Católica de Temuco  
Temuco, Chile  
<jrojas@inf.uct.cl>

## Installation

You can install the stable version of \<package.name> from CRAN with:

``` r
# install.packages(“foRgotten”)
```

and the development version from GitHub with:

``` r
#install.packages(“devtools”)
#devtools::install_github("ElliottMardones/foRgotten")
```

## Usage

``` r
library(test10)#cambiar a foRgotten despues
```

## 

## Functions

The package provides five functions:

``` r
?directEffects
#> starting httpd help server ... done
```

Computes the mean incidence, lower confidence interval, and p-value with
multiple key informants for complete graphs and chained bipartite
graphs. For more details, see help (de.sq).

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

The book store presents the data with the average between the minimum
and maximum value for each incidence, A being the equivalent to
incentives and B to behaviors. For more details of the data you can
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

The `directEffects()` function makes use of the `“boot.one.bca”`
function of the `wBoot` package to implement the bootstrap method with
BCa adjusted boot and with a left one-sided hypothesis test based on the
Z-test. The `conf.level` parameter defines the confidence level and
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
#>   From To  Mean    UCI p.value
#> 1   I1 I2 0.525 0.6300   0.575
#> 2   I1 I3 0.450 0.5861   0.293
#> 3   I1 I4 0.525 0.6654   0.609
#> 4   I1 I5 0.465 0.6450   0.375
#> 5   I1 I6 0.645 0.7850   0.895
#> 6   I1 I7 0.815 0.8700   1.000
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

The `bootMargin()` function makes use of the `“boot.one.bca”` function
from the `wBoot` package to implement the bootstrap resampling method
with BCa adjusted boot and with a two-sided hypothesis test based on the
Z-test. The `conf.level` parameter defines the confidence level and
`reps` the number of bootstrap replicas. By default `conf.level = 0.95`
and `reps = 10000`.

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
#> 1   I1 0.5255433 0.4675 0.5875 2.91e-02
#> 2   I2 0.5994003 0.5515 0.6579 9.66e-01
#> 3   I3 0.4280310 0.3590 0.4703 7.73e-05
#> 4   I4 0.4905413 0.4008 0.5421 2.94e-05
#> 5   I5 0.5344293 0.4717 0.5977 4.30e-02
#> 6   I6 0.5539760 0.4773 0.6167 1.25e-01
#> 7   I7 0.5315417 0.4818 0.5835 1.10e-02
#> 8   I8 0.5427540 0.4663 0.6134 1.13e-01
#> 9   I9 0.4643607 0.4060 0.5165 4.25e-04
#> 10 I10 0.4731567 0.3930 0.5400 4.28e-04
#> 11 I11 0.5974773 0.5503 0.6423 8.91e-01
#> 12 I12 0.4559787 0.3943 0.4987 6.48e-05
#> 13 I13 0.5539730 0.4700 0.6363 2.52e-01
#> 14 I14 0.2485857 0.2049 0.2980 1.44e-03
#> 15 I15 0.4426557 0.3927 0.4950 1.48e-03
#> 16 I16 0.5140877 0.4532 0.5627 4.41e-04
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.4803423 0.3666 0.5719 0.011600
#> 2   I2 0.5521307 0.4294 0.6547 0.384000
#> 3   I3 0.4186917 0.3133 0.5110 0.000675
#> 4   I4 0.4692143 0.3539 0.5916 0.039300
#> 5   I5 0.4575023 0.3578 0.5532 0.000559
#> 6   I6 0.5872893 0.3857 0.6677 0.733000
#> 7   I7 0.5562813 0.4408 0.6485 0.417000
#> 8   I8 0.5743783 0.5063 0.6502 0.478000
#> 9   I9 0.4531933 0.3364 0.5476 0.002950
#> 10 I10 0.4636727 0.3800 0.5791 0.018000
#> 11 I11 0.5774543 0.4310 0.6927 0.724000
#> 12 I12 0.4563103 0.3341 0.5764 0.014500
#> 13 I13 0.5636160 0.4761 0.6353 0.330000
#> 14 I14 0.2733193 0.1853 0.3371 0.000199
#> 15 I15 0.4720647 0.3593 0.5930 0.040700
#> 16 I16 0.5914300 0.5164 0.6933 0.915000
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
#>    Var      Mean    LCI    UCI p.value
#> 2   I2 0.6003730 0.5477 0.6533 0.97300
#> 5   I5 0.5336233 0.4730 0.6047 0.07770
#> 6   I6 0.5536140 0.4790 0.6164 0.17600
#> 7   I7 0.5302397 0.4799 0.5818 0.00816
#> 8   I8 0.5435877 0.4643 0.6093 0.10300
#> 11 I11 0.5974457 0.5538 0.6495 0.94000
#> 13 I13 0.5542533 0.4753 0.6398 0.26500
#> 15 I15 0.4408610 0.3917 0.4939 0.00180
#> 16 I16 0.5129870 0.4541 0.5649 0.00358
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI  p.value
#> 2   I2 0.5552910 0.4249 0.6597 0.422000
#> 5   I5 0.4609383 0.3559 0.5459 0.000277
#> 6   I6 0.5878387 0.4093 0.6700 0.776000
#> 7   I7 0.5558383 0.4350 0.6575 0.390000
#> 8   I8 0.5744267 0.5113 0.6519 0.487000
#> 11 I11 0.5760340 0.4348 0.6976 0.745000
#> 13 I13 0.5614550 0.4846 0.6372 0.364000
#> 15 I15 0.4726193 0.3480 0.6017 0.061500
#> 16 I16 0.5929490 0.5190 0.6762 0.887000
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
#> 1   I1 0.5151763 0.4697 0.5646 0.004940
#> 2   I2 0.6292071 0.5810 0.6773 0.214000
#> 3   I3 0.4569737 0.3939 0.5247 0.001630
#> 4   I4 0.5099500 0.4502 0.5729 0.002360
#> 5   I5 0.5479624 0.4920 0.6071 0.075200
#> 6   I6 0.5819237 0.5146 0.6524 0.621000
#> 7   I7 0.5735553 0.5188 0.6301 0.381000
#> 8   I8 0.5724137 0.5017 0.6371 0.414000
#> 9   I9 0.4796082 0.4162 0.5403 0.002890
#> 10 I10 0.5159689 0.4442 0.5926 0.030100
#> 11 I11 0.6527029 0.5970 0.7190 0.069600
#> 12 I12 0.4782905 0.4124 0.5313 0.000708
#> 13 I13 0.6236258 0.5380 0.7139 0.589000
#> 14 I14 0.2443937 0.2040 0.2807 0.000833
#> 15 I15 0.4595650 0.4187 0.5096 0.001250
#> 16 I16 0.5279329 0.4812 0.5713 0.001540
#> 17  B1 0.6780183 0.6000 0.7200 0.203000
#> 18  B2 0.6784550 0.5700 0.7550 0.152000
#> 19  B3 0.6737850 0.5500 0.7717 0.493000
#> 20  B4 0.8084783 0.8000 0.8150 0.000753
```

For `$byCol`

``` r
result$byCol
#>    Var      Mean    LCI    UCI  p.value
#> 1   I1 0.4792417 0.3635 0.5734 6.79e-03
#> 2   I2 0.5564770 0.4295 0.6560 3.96e-01
#> 3   I3 0.4205187 0.3153 0.5110 5.59e-04
#> 4   I4 0.4689753 0.3438 0.5823 2.54e-02
#> 5   I5 0.4617787 0.3550 0.5435 1.29e-03
#> 6   I6 0.5841477 0.4211 0.6725 8.13e-01
#> 7   I7 0.5578120 0.4368 0.6534 3.89e-01
#> 8   I8 0.5741100 0.5117 0.6463 4.53e-01
#> 9   I9 0.4477490 0.3483 0.5648 1.43e-02
#> 10 I10 0.4680223 0.3611 0.5744 1.92e-02
#> 11 I11 0.5800763 0.4337 0.7040 7.48e-01
#> 12 I12 0.4567530 0.3241 0.5566 1.09e-02
#> 13 I13 0.5640473 0.4715 0.6353 2.79e-01
#> 14 I14 0.2744593 0.1881 0.3358 1.46e-04
#> 15 I15 0.4747730 0.3534 0.5854 2.86e-02
#> 16 I16 0.5927650 0.5120 0.6756 8.81e-01
#> 17  B1 0.5394645 0.4434 0.6576 3.19e-01
#> 18  B2 0.6761287 0.6108 0.7687 1.94e-02
#> 19  B3 0.6904068 0.6339 0.7689 8.56e-05
#> 20  B4 0.6276187 0.5391 0.7255 5.28e-01
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

The `centrality()` function makes use of the `“boot”` function from the
boot package (Canty A, Ripley BD, 2021) to implement the bootstrap
method with BCa tight boot. The number of bootstrap replicas is defined
in the `reps`parameter. By default `reps = 10000`.

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
#> 1   I1 13.1666667 0.0000000 21.358333 median
#> 2   I2 12.9875000 2.7055613 25.430556 median
#> 3   I3  0.0000000 0.0000000  0.000000 median
#> 4   I4  0.8333333 0.0000000  2.079167 median
#> 5   I5  6.2083333 0.4958333 10.250000 median
#> 6   I6 20.2791667 4.8070548 36.000000 median
#> 7   I7 11.0833333 1.7500000 41.000000 median
#> 8   I8  4.7083333 0.1000000 10.333333 median
#> 9   I9  0.0000000 0.0000000  0.000000 median
#> 10 I10  1.5000000 0.0000000  8.125000 median
#> 11 I11 15.8333333 3.1942299 30.416667 median
#> 12 I12  0.0000000 0.0000000  0.000000 median
#> 13 I13  4.7916667 0.7763065 11.000000 median
#> 14 I14  0.0000000 0.0000000  0.000000 median
#> 15 I15  2.5000000 0.0000000  8.583333 median
#> 16 I16 13.1666667 2.5833333 28.458333 median
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
#> 1   I1 13.1666667 0.0000000 26.221124 median
#> 2   I2 12.9875000 2.2500000 25.166667 median
#> 3   I3  0.0000000 0.0000000  0.000000 median
#> 4   I4  0.8333333 0.0000000  3.102966 median
#> 5   I5  6.2083333 0.6666667 10.655172 median
#> 6   I6 20.2791667 4.7074397 42.583333 median
#> 7   I7 11.0833333 1.9107598 41.000000 median
#> 8   I8  4.7083333 0.1000000 10.833333 median
#> 9   I9  0.0000000 0.0000000  0.000000 median
#> 10 I10  1.5000000 0.0000000  8.125000 median
#> 11 I11 15.8333333 2.6250000 30.416667 median
#> 12 I12  0.0000000 0.0000000  0.000000 median
#> 13 I13  4.7916667 0.5000000 11.000000 median
#> 14 I14  0.0000000 0.0000000  0.000000 median
#> 15 I15  2.5000000 0.0000000  7.291667 median
#> 16 I16 13.1666667 2.5833333 28.458333 median
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
#>    Var     Median       LCI       UCI Method
#> 1   I1 13.1666667 0.0000000 21.358333 median
#> 2   I2 12.9875000 2.2500000 24.125000 median
#> 3   I3  0.0000000 0.0000000  0.000000 median
#> 4   I4  0.8333333 0.0000000  1.995833 median
#> 5   I5  6.2083333 0.4958333 10.000000 median
#> 6   I6 20.2791667 4.4964274 36.000000 median
#> 7   I7 11.0833333 1.5000000 31.700000 median
#> 8   I8  4.7083333 0.1000000 10.833333 median
#> 9   I9  0.0000000 0.0000000  0.000000 median
#> 10 I10  1.5000000 0.0000000  8.125000 median
#> 11 I11 15.8333333 0.6950687 30.416667 median
#> 12 I12  0.0000000 0.0000000  0.000000 median
#> 13 I13  4.7916667 0.0000000  9.916667 median
#> 14 I14  0.0000000 0.0000000  0.000000 median
#> 15 I15  2.5000000 0.0000000  9.211933 median
#> 16 I16 13.1666667 2.5833333 28.458333 median
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
#> 1   I1 14.0416667  0.0000000 31.883333 median
#> 2   I2 14.6913273  7.9899228 17.799567  conpl
#> 3   I3  0.0000000  0.0000000  0.000000 median
#> 4   I4  0.9166667  0.1666667  4.708333 median
#> 5   I5  6.2083333  0.6710528 13.041667 median
#> 6   I6 24.6720238  4.5607143 48.975000 median
#> 7   I7  9.2552918  1.1172637 25.079716  conpl
#> 8   I8  8.2761905  3.7500000 21.294048 median
#> 9   I9  0.3750000  0.0000000  3.650000 median
#> 10 I10  1.5714286  0.1666667  8.125000 median
#> 11 I11 21.0241962 13.7066578 21.438612  conpl
#> 12 I12  3.3333333  0.0000000 11.318238 median
#> 13 I13  5.0166667  1.1428571 14.434524 median
#> 14 I14  0.0000000  0.0000000  0.000000 median
#> 15 I15  2.5000000  0.0000000  9.166667 median
#> 16 I16 18.7916667  2.5833333 39.019637 median
#> 17  B1  0.0000000  0.0000000  0.000000 median
#> 18  B2  2.7833333  1.0000000  5.500000 median
#> 19  B3  2.0000000  0.5000000  3.333333 median
#> 20  B4  1.8666667  0.0000000  6.965270 median
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

The `fe.sq()` function makes use of the `“boot”` function from the boot
package (Canty A, Ripley BD, 2021) to implement bootstrap with BCa tight
boot. The number of bootstrap replicas is defined in the `reps`
parameter. By default `reps = 10000`.

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
#> 1   I8       I11 I10     4 0.6125000 0.5625 0.6750000 0.02652208
#> 2   I5       I11 I10     3 0.6166667 0.5500 0.6666667 0.03671591
#> 3   I6       I11 I14     3 0.6833333 0.6000 0.7666667 0.07021737
#> 4  I13       I11 I14     3 0.5833333 0.5500 0.6000000 0.01399985
#> 5  I13        I6  I1     3 0.6333333 0.6000 0.6666667 0.02748039
#> 6  I13       I16  I1     3 0.6333333 0.6000 0.6666667 0.02785307
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

The `fe.rect()` function makes use of the `“boot”` function from the
boot package (Canty A, Ripley BD, 2021) to implement bootstrap with BCa
tight boot.. The number of bootstrap replicas is defined in the `reps`
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
#> 1   I5        B4 B1     3 0.6333333 0.60 0.6666667 0.02745863
#> 2   I6        I7 B1     2 0.8000000 0.75 0.8000000 0.03469411
#> 3   I8        I7 B1     2 0.6250000 0.60 0.6250000 0.01775705
#> 4  I12        I2 B1     2 0.7000000 0.65 0.7500000 0.03593144
#> 5  I10       I11 B2     2 0.5750000 0.55 0.5750000 0.01719826
#> 6  I14       I15 B2     2 0.7250000 0.70 0.7500000 0.01807081
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
