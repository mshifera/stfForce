# WRITE TO SPECIFIED CREDENTIAL VARIABLES

devtools::load_all()

# Checks that a variable is written in all parameter permutations

sf_store_creds(username = 'foo', password = 'bar', token = 'baz')

test_that("A variable is written for the specified variables", {
  expect_equal(Sys.getenv("SF_USER"), "foo")
  expect_equal(Sys.getenv("SF_PASSWORD"), "bar")
  expect_equal(Sys.getenv("SF_TOKEN"), "baz")
})
