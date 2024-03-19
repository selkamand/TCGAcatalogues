test_that("catalogues_available works", {

  # No error thrown
  expect_error(catalogues_available(), NA)

  # Returns Data Frame
  expect_true(is.data.frame(catalogues_available()))

  # Data frame is non-empty
  expect_gt(nrow(catalogues_available()), 0)

})


test_that("catalogues_load works", {

  # No error thrown
  expect_error(catalogues_load('ACC'), NA)

  # Returns list
  acc_collection <- catalogues_load('ACC')
  expect_true(is.list(acc_collection) & !is.data.frame(acc_collection))

  # List is non-empty
  expect_gt(length(acc_collection), 0)


  # Returns Data Frame If dataframe = TRUE
  expect_true(is.data.frame(catalogues_load('ACC', dataframe = TRUE)))



})
