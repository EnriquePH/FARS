#  ----------------------------------------------------------------------------
#  fars: read, summarise and map FARS data
#  File: fars_functions.R
#  (c) 2017-2026 Enrique Pérez Herrero
#  GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#  First written for the Coursera "Building R Packages" peer-graded assignment
#  (May 2017); updated in 2026 for current dplyr and tidyr.
#  ----------------------------------------------------------------------------

#' Read a file of FARS data
#'
#' Reads a CSV file (it can be compressed, e.g. `.csv.bz2`) from the
#' **US National Highway Traffic Safety Administration's** *Fatality Analysis
#' Reporting System* (FARS), a nationwide census with yearly data about the
#' fatal injuries suffered in motor vehicle traffic crashes.
#'
#' @details For more information, see:
#' * <https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars>
#' * <https://en.wikipedia.org/wiki/Fatality_Analysis_Reporting_System>
#'
#' @param filename Path of the file to read. [make_filename()] gives the path
#'   of the files shipped with the package.
#'
#' @return A tibble with one row per accident.
#' @seealso [make_filename()]
#' @examples
#' accidents <- fars_read(make_filename(2015))
#' dim(accidents)
#' @export
fars_read <- function(filename) {
  if (!file.exists(filename)) {
    stop("file '", filename, "' does not exist", call. = FALSE)
  }
  tibble::as_tibble(utils::read.csv(filename, stringsAsFactors = FALSE))
}

#' Path of the FARS data file of a year
#'
#' The package ships the accident files of 2013, 2014 and 2015.
#'
#' @param year Year, as a number or a string.
#'
#' @return The path of `accident_<year>.csv.bz2` inside the package; an error
#'   if there is no file for that year.
#' @seealso [fars_read()]
#' @examples
#' make_filename(2013)
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  system.file("extdata", sprintf("accident_%d.csv.bz2", year),
              package = "fars", mustWork = TRUE)
}

#' Read the month of every accident of some years
#'
#' Helper of [fars_summarize_years()].
#'
#' @param years Vector of years.
#'
#' @return A list with one element per year: a tibble with the columns `MONTH`
#'   and `year`, or `NULL` (with a warning) when there is no data for that
#'   year.
#' @seealso [fars_read()], [make_filename()], [fars_summarize_years()]
#' @examples
#' str(fars_read_years(2013))
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    tryCatch({
      dat <- fars_read(make_filename(year))
      dat |>
        dplyr::mutate(year = .data$YEAR) |>
        dplyr::select("MONTH", "year")
    }, error = function(e) {
      warning("invalid year: ", year, call. = FALSE)
      NULL
    })
  })
}

#' Number of accidents by month and year
#'
#' @param years Vector of years.
#'
#' @return A tibble with one row per month (`MONTH`) and one column per year
#'   with the number of accidents. Years without data are left out, with a
#'   warning.
#' @seealso [fars_read_years()]
#' @examples
#' fars_summarize_years(c(2014, 2015))
#' @export
fars_summarize_years <- function(years) {
  fars_read_years(years) |>
    dplyr::bind_rows() |>
    dplyr::count(.data$year, .data$MONTH) |>
    tidyr::pivot_wider(names_from = "year", values_from = "n")
}

#' Map the accidents of a state in a year
#'
#' Draws the map of the state and a point for every accident of that year.
#' Locations coded as unknown (longitude above 900, latitude above 90) are
#' left out.
#'
#' @param state.num State code (number), from 1 (Alabama) to 56 (Wyoming); the
#'   codes follow the FARS coding manual:
#' \tabular{cc}{
#'   \strong{State Code} \tab \strong{State Name}    \cr
#'   01 \tab  Alabama              \cr
#'   02 \tab  Alaska               \cr
#'   04 \tab  Arizona              \cr
#'   05 \tab  Arkansas             \cr
#'   06 \tab  California           \cr
#'   08 \tab  Colorado             \cr
#'   09 \tab  Connecticut          \cr
#'   10 \tab  Delaware             \cr
#'   11 \tab  District of Columbia \cr
#'   12 \tab  Florida              \cr
#'   13 \tab  Georgia              \cr
#'   15 \tab  Hawaii               \cr
#'   16 \tab  Idaho                \cr
#'   17 \tab  Illinois             \cr
#'   18 \tab  Indiana              \cr
#'   19 \tab  Iowa                 \cr
#'   20 \tab  Kansas               \cr
#'   21 \tab  Kentucky             \cr
#'   22 \tab  Louisiana            \cr
#'   23 \tab  Maine                \cr
#'   24 \tab  Maryland             \cr
#'   25 \tab  Massachusetts        \cr
#'   26 \tab  Michigan             \cr
#'   27 \tab  Minnesota            \cr
#'   28 \tab  Mississippi          \cr
#'   29 \tab  Missouri             \cr
#'   30 \tab  Montana              \cr
#'   31 \tab  Nebraska             \cr
#'   32 \tab  Nevada               \cr
#'   33 \tab  New Hampshire        \cr
#'   34 \tab  New Jersey           \cr
#'   35 \tab  New Mexico           \cr
#'   36 \tab  New York             \cr
#'   37 \tab  North Carolina       \cr
#'   38 \tab  North Dakota         \cr
#'   39 \tab  Ohio                 \cr
#'   40 \tab  Oklahoma             \cr
#'   41 \tab  Oregon               \cr
#'   42 \tab  Pennsylvania         \cr
#'   43 \tab  Puerto Rico          \cr
#'   44 \tab  Rhode Island         \cr
#'   45 \tab  South Carolina       \cr
#'   46 \tab  South Dakota         \cr
#'   47 \tab  Tennessee            \cr
#'   48 \tab  Texas                \cr
#'   49 \tab  Utah                 \cr
#'   50 \tab  Vermont              \cr
#'   51 \tab  Virginia             \cr
#'   52 \tab  Virgin Islands       \cr
#'   53 \tab  Washington           \cr
#'   54 \tab  West Virginia        \cr
#'   55 \tab  Wisconsin            \cr
#'   56 \tab  Wyoming
#' }
#' @param year Year, as a number or a string.
#'
#' @return `NULL`, invisibly; called for the plot. An error if the state code
#'   is not in the data of that year.
#' @references 2014 FARS/NASS GES Coding and Validation Manual.
#' @seealso [fars_read()], [make_filename()]
#' @examples
#' fars_map_state(49, 2015)
#' @export
fars_map_state <- function(state.num, year) {
  data <- fars_read(make_filename(year))
  state.num <- as.integer(state.num)
  if (!(state.num %in% unique(data$STATE))) {
    stop("invalid STATE number: ", state.num, call. = FALSE)
  }
  data.sub <- dplyr::filter(data, .data$STATE == state.num)
  if (nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  maps::map("state", ylim = range(data.sub$LATITUDE, na.rm = TRUE),
            xlim = range(data.sub$LONGITUD, na.rm = TRUE))
  graphics::points(data.sub$LONGITUD, data.sub$LATITUDE, pch = 46)
  invisible(NULL)
}
