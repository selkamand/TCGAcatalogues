test_that("decomp_available works", {

  # No error thrown
  expect_error(decomp_available(), NA)

  # Returns Data Frame
  expect_true(is.data.frame(decomp_available()))

  # Data frame is non-empty
  expect_gt(nrow(decomp_available()), 0)

})


test_that("decomp_load works", {

  # No error thrown
  expect_error(decomp_load('ACC'), NA)

  # Returns list
  acc_collection <- decomp_load('ACC')
  expect_true(is.list(acc_collection) & !is.data.frame(acc_collection))

  # List is non-empty
  expect_gt(length(acc_collection), 0)


  # Returns Data Frame If dataframe = TRUE
  expect_true(is.data.frame(decomp_load('ACC', dataframe = TRUE)))



})
