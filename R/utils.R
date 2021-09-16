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

write_variable <- function(
  variable_name, 
  variable_value, 
  overwrite = FALSE, 
  install = FALSE
){
  
  if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if(file.exists(renv)){
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if(!file.exists(renv)){
      file.create(renv)
    }
    else{
      if(all(!file.exists(renv), isTRUE(overwrite))){
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv=read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep(variable_name, oldenv),]
        write.table(newenv, renv, quote = FALSE, sep = "\n",
                    col.names = FALSE, row.names = FALSE)
      }
      else{
        tv <- readLines(renv)
        if(any(grepl(variable_name,tv))){
          stop(paste0(variable_name, " already exists. You can overwrite it with the argument overwrite=TRUE"), call.=FALSE)
        }
      }
    }
    
    valueconcat <- paste0(variable_name, "='", variable_value, "'")
    # Append variable_name to .Renviron file
    write(valueconcat, renv, sep = "\n", append = TRUE)
    message(paste0(variable_name, " has been stored in your .Renviron and can be accessed by Sys.getenv('", variable_name, "'). To use now, restart R or run `readRenviron('~/.Renviron')`"))
    return(variable_value)
  } else {
    message(paste0("To install ", variable_name, " for use in future sessions, run this function with `install = TRUE`."))
    
    do.call(Sys.setenv, as.list(setNames(variable_value, variable_name)))
    
  }
  
}

`%notin%` <- Negate(`%in%`)
