context("report_association")

# load in some example data
data(mtcars, band_instruments, nasa, starwars, storms, airquality)

test_that("Output is a data frame", {
  expect_is(report_association(mtcars), "data.frame")
  expect_is(report_association(band_instruments), "data.frame")
  expect_error(report_association(nasa))
  expect_is(report_association(starwars), "data.frame")
  expect_is(report_association(storms), "data.frame")
  expect_is(report_association(airquality), "data.frame")
})

test_that("Output with two identical df inputs data frame", {
  expect_is(report_association(mtcars, mtcars), "data.frame")
  expect_is(report_association(band_instruments, band_instruments), "data.frame")
  expect_is(report_association(starwars, starwars), "data.frame")
  expect_is(report_association(storms, storms), "data.frame")
  expect_is(report_association(airquality, airquality), "data.frame")
})

test_that("Output with two different inputs data frame", {
  set.seed(10)
  expect_is(report_association(mtcars, mtcars %>% sample_n(100, replace = T)), "data.frame")
  expect_is(report_association(band_instruments, band_instruments %>% sample_n(100, replace = T)) , "data.frame")
  expect_is(report_association(starwars, starwars %>% sample_n(100, replace = T)), "data.frame")
  expect_is(report_association(storms, storms %>% sample_n(100, replace = T)), "data.frame")
  expect_is(report_association(airquality, airquality%>% sample_n(100, replace = T)), "data.frame")
})

