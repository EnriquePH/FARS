[![R-CMD-check](https://github.com/EnriquePH/FARS/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EnriquePH/FARS/actions/workflows/R-CMD-check.yaml)
[![R >= 4.1](https://img.shields.io/badge/R-%3E%3D4.1-276DC3.svg?logo=r)](https://www.r-project.org/)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# fars

Read, summarise and map the accident data of the US National Highway Traffic
Safety Administration's
[Fatality Analysis Reporting System](https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars)
(FARS), a nationwide census of the fatal injuries suffered in motor vehicle
traffic crashes. The package ships the accident files of 2013, 2014 and 2015.

## Installation

```r
# install.packages("remotes")
remotes::install_github("EnriquePH/FARS", build_vignettes = TRUE)
```

## Usage

```r
library(fars)

make_filename(2015)                  # path of the 2015 file
accidents <- fars_read(make_filename(2015))
fars_summarize_years(c(2014, 2015))  # accidents by month and year
fars_map_state(49, 2015)             # accidents in Utah in 2015
vignette("fars")
```

| Function | What it does |
|---|---|
| `make_filename(year)` | Path of the data file of a year |
| `fars_read(filename)` | Reads a (compressed) CSV file as a tibble |
| `fars_read_years(years)` | Month and year of every accident; `NULL` with a warning for a year without data |
| `fars_summarize_years(years)` | Number of accidents by month (rows) and year (columns) |
| `fars_map_state(state.num, year)` | Map of a state with a point for every accident |

## History

First written in May 2017 for the peer-graded assignment of the Coursera
course *Building R Packages* (Mastering Software Development in R
Specialization); that version is kept as the tag
[`coursera-2017`](https://github.com/EnriquePH/FARS/tree/coursera-2017).
Version 1.0.0 (2026) updates it to current dplyr and tidyr, fixes the
handling of invalid years, drops the readr and magrittr dependencies and moves
CI from Travis and AppVeyor to GitHub Actions. See [NEWS.md](NEWS.md).

## Author

Enrique Pérez Herrero · GPL-3
