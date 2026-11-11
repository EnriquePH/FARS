test_that("the accident files of 2013-2015 are shipped", {
  expect_equal(
    list.files(system.file("extdata", package = "fars")),
    c("accident_2013.csv.bz2", "accident_2014.csv.bz2", "accident_2015.csv.bz2")
  )
})

test_that("make_filename() finds a year and fails for a missing one", {
  expect_match(make_filename("2014"), "accident_2014\\.csv\\.bz2$")
  expect_error(make_filename(1999))
})

test_that("fars_read() reads a file and fails for a missing one", {
  accidents <- fars_read(make_filename(2013))
  expect_s3_class(accidents, "tbl_df")
  expect_equal(nrow(accidents), 30202)
  expect_true(all(c("STATE", "MONTH", "YEAR", "LATITUDE", "LONGITUD") %in% names(accidents)))
  expect_error(fars_read("no-such-file.csv"), "does not exist")
})
