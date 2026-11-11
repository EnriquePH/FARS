# fars 1.0.0 (2026-11-11)

* Updated to current dplyr and tidyr: the deprecated underscore verbs
  (`mutate_()`, `select_()`, `group_by_()`, `summarize_()`, `filter_()`),
  `tbl_df()` and `spread_()` are replaced by `mutate()`, `select()`,
  `count()`, `filter()` with the `.data` pronoun, `tibble::as_tibble()` and
  `tidyr::pivot_wider()`.
* `fars_read_years()` now returns `NULL` with a warning for a year without
  data, as documented; before, `make_filename()` raised an error first.
* `fars_map_state()` returns `NULL` invisibly.
* Files are read with `utils::read.csv()`, which reads `.csv.bz2` directly:
  readr and magrittr are no longer needed (the native pipe `|>` needs
  R >= 4.1).
* Tests rewritten for testthat 3rd edition, covering every function.
* CI moved from Travis and AppVeyor to GitHub Actions (`R CMD check` on
  Linux, macOS and Windows).
* Documentation in Markdown (roxygen2), complete DESCRIPTION and README.

# fars 0.0.0.3 (2017-05-18)

* Coursera *Building R Packages* peer-graded assignment (tag `coursera-2017`).
