# GENERAL UTILITY FUNCTIONS FOR WRITING ENVIRONMENT VARIABLES

# Clears renviron for testing

clean_renviron <- function() {
  # Read line by line .Renviron
  home <- Sys.getenv("HOME")
  renv <- file.path(home, ".Renviron")
  if (file.exists(renv)) {
    # Backup original .Renviron before doing anything else here.
    file.copy(renv, file.path(home, ".Renviron_backup"), overwrite = TRUE)
    
    con <- file(renv, open = "r")
    lines <- as.character()
    ii <- 1
    
    while (TRUE) {
      line <- readLines(con, n = 1, warn = FALSE)
      if (length(line) == 0) {
        break()
      }
      lines[ii] <- line
      ii <- ii + 1
    }
    on.exit(close(con), add = TRUE)
    
    # Remove system variables for testing
    system_vars <- lines[!grepl("foo|baz|quux|corge", lines)]
    fileConn <- file(renv)
    writeLines(system_vars, fileConn)
    on.exit(close(fileConn), add = TRUE)
  }
  invisible(TRUE)
}

devtools::load_all()

# Checks that a variable is written in all parameter permutations

clean_renviron()
write_variable("foo", "bar", TRUE, FALSE)
write_variable("baz", "qux", FALSE, TRUE)
write_variable("quux", "quuz", FALSE, FALSE)
write_variable("corge", "grault", TRUE, TRUE)
readRenviron("~/.Renviron")

test_that("A variable is written in all parameter permutations", {
  # foo
  expect_equal(Sys.getenv("foo"), "bar")
  # baz
  expect_equal(Sys.getenv("baz"), "qux")
  # quux
  expect_equal(Sys.getenv("quux"), "quuz")
  # corge
  expect_equal(Sys.getenv("corge"), "grault")  
})

clean_renviron()
write_variable("baz", "qux", FALSE, TRUE)

test_that("Overwrite is prevented", {

    expect_error(write_variable("baz", "qux", FALSE, TRUE))

})

clean_renviron()
