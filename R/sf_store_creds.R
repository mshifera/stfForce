

#' Install SalesForce credentials in Your \code{.Renviron} File for Repeated Use
#' @description This function will add your username, password, and SalesForce 
#' API token to your \code{.Renviron} file so it can be called securely without 
#' being stored in your code. After you have installed your variables, they
#' the variables can be called any time by typing \code{Sys.getenv("SF_USER")}, 
#' \code{Sys.getenv("SF_PASSWORD")}, or \code{Sys.getenv("SF_TOKEN")}. If you do 
#' not have an \code{.Renviron} file, the function will create on for you.
#' If you already have an \code{.Renviron} file, the function will append the 
#' variables to your existing file, while making a backup of your original file 
#' for disaster recovery purposes.
#' 
#' You can update all of your variables at once, or update them one at a time. 
#' @param username The email address you use to login to SalesForce formatted in quotes.
#' @param password The password you use to login to SalesForce formatted in quotes.
#' @param token The API token provided to you from SalesForce formatted in quotes. A key can be acquired as described here \url{https://help.salesforce.com/s/articleView?id=sf.user_security_token.htm&type=5}
#' @param overwrite If this is set to TRUE, it will overwrite the existing variables that you already have in your \code{.Renviron} file.
#' @param install if TRUE, will install your credentials in your \code{.Renviron} file for use in future sessions.  Defaults to FALSE.
#'
#' @return
#' @export
#' @examples
#'
#' \dontrun{
#' sf_store_creds(username = 'foo', password = 'bar', token = 'baz', 
#' overwrite = TRUE, install = TRUE)
#' # First time, reload your environment so you can use the key without restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("SF_USER")
#' Sys.getenv("SF_PASSWORD")
#' Sys.getenv("SF_TOKEN")
#' }
#'
#' \dontrun{
#' # If you need to overwrite an existing key:
#' sf_store_creds(username = 'foo', password = 'bar', token = 'baz', 
#' overwrite = TRUE, install = TRUE)
#' # First time, reload your environment so you can use the key without restarting R.
#' readRenviron("~/.Renviron")
#' # You can check it with:
#' Sys.getenv("SF_USER")
#' Sys.getenv("SF_PASSWORD")
#' Sys.getenv("SF_TOKEN")
#' }
#' }
#' @export
sf_store_creds <- function(
  username = NULL, 
  password = NULL, 
  token = NULL, 
  overwrite = FALSE, 
  install = FALSE
){
  if (!is.null(username)) {
    message(
      'Assigning SF_USER...'
    )
    write_variable(
      variable_name = 'SF_USER',
      variable_value = username,
      overwrite = overwrite,
      install = install
    )
  }
  
  if (!is.null(password)) {
    message(
      'Assigning SF_PASSWORD...'
    )
    write_variable(
      variable_name = 'SF_PASSWORD',
      variable_value = password,
      overwrite = overwrite,
      install = install
    )
  }
  if (!is.null(token)) {
    message(
      'Assigning SF_TOKEN...'
    )
    write_variable(
      variable_name = 'SF_TOKEN',
      variable_value = token,
      overwrite = overwrite,
      install = install
    )
  }
  
  
  
}
