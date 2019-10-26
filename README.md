
# `ValleyBikes`

The `ValleyBikes` package aims to make it easier to explore and analyze
public data from the Pioneer Valley bikeshare initiative: [Valley
Bike](https://valleybike.org/).

## Installation Instructions

The `ValleyBikes` package is online available for everyone. To install
you will need the `devtools` package.

``` r
# install the development version from GitHub
devtools::install_github("Amherst-Statistics/ValleyBikes")
```

    ## Skipping install of 'ValleyBikes' from a github remote, the SHA1 (e1113ccb) has not changed since last install.
    ##   Use `force = TRUE` to force installation

To load the package we do:

``` r
library(ValleyBikes)
```

Now we can begin exploring bike data\!

## Looking at the Data

There are two tables in our data package:

  - `stations`: contains information about all the stations.
  - `routes`: contains the start and end entries for all bike rides
    (routes) taken.

Let’s take a look at the `stations` table:

``` r
head(stations)
```

    ## # A tibble: 6 x 7
    ##   serial_num address station_name num_docks latitude longitude
    ##        <dbl> <chr>   <chr>            <int>    <dbl>     <dbl>
    ## 1         19 330 Ho… Holyoke Com…        16     42.2     -72.7
    ## 2         50 Congre… Congress St…        10     42.1     -72.6
    ## 3         17 South … South Holyo…        15     42.2     -72.6
    ## 4         22 YMCA/C… YMCA/Childs…        17     42.3     -72.6
    ## 5         23 20 Wes… Forbes Libr…        13     42.3     -72.6
    ## 6         13 Spring… Springdale …         4     42.2     -72.6
    ## # … with 1 more variable: community_name <chr>

Now let’s take a look at the `routes` table:

``` r
head(routes)
```

    ## # A tibble: 6 x 6
    ##   route_id              bike  date       latitude longitude user_id        
    ##   <chr>                 <chr> <chr>         <dbl>     <dbl> <chr>          
    ## 1 route_06_2018@dd8965… 924   2018-06-2…     42.3     -72.6 1cc1e858-857a-…
    ## 2 route_06_2018@dd8965… 924   2018-06-2…     42.3     -72.6 1cc1e858-857a-…
    ## 3 route_06_2018@3e2b06… 984   2018-06-2…     42.3     -72.6 72491657-3115-…
    ## 4 route_06_2018@3e2b06… 984   2018-06-2…     42.3     -72.6 72491657-3115-…
    ## 5 route_06_2018@8b26d1… 935   2018-06-2…     42.3     -72.6 72491657-3115-…
    ## 6 route_06_2018@8b26d1… 935   2018-06-2…     42.3     -72.6 72491657-3115-…
