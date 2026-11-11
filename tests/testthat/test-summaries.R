test_that("fars_read_years() returns month and year of every accident", {
  out <- fars_read_years(2013)
  expect_length(out, 1)
  expect_named(out[[1]], c("MONTH", "year"))
  expect_equal(nrow(out[[1]]), 30202)
  expect_true(all(out[[1]]$year == 2013))
})

test_that("an invalid year gives a warning and NULL, not an error", {
  expect_warning(out <- fars_read_years(c(2013, 1999)), "invalid year: 1999")
  expect_null(out[[2]])
})

test_that("fars_summarize_years() counts accidents by month and year", {
  s <- fars_summarize_years(c(2014, 2015))
  expect_named(s, c("MONTH", "2014", "2015"))
  expect_equal(nrow(s), 12)
  expect_equal(sum(s[["2014"]]), nrow(fars_read(make_filename(2014))))
})

test_that("fars_map_state() draws a state and rejects unknown codes", {
  pdf(NULL)
  on.exit(dev.off())
  expect_null(fars_map_state(49, 2015))
  expect_error(fars_map_state(3, 2015), "invalid STATE number: 3")
})
