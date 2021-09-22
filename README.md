
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stfForce

The goal of `stfForce` is to provide a wrapper to the SalesForce API and
the `salesforcer` package.

This package will be specifically geared toward users from the Stand
Together Foundation, but may be generally useful to others.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("stand-together-foundation/stfForce")
```

## Example

To get started working with `stfForce`, users should load the package
along with the `tidyverse` package, and set their SalesForce
credentials.

``` r
library(stfForce)
library(salesforcer)
library(tidyverse)


sf_store_creds(
  username = "jmienko@standtogether.org", 
  password = "bigjose0095", 
  token = "VMO9e9XrvvuedueFpj33BVvL"
)

sf_auth(
  username = Sys.getenv('SF_USER'), 
  password = Sys.getenv('SF_PASSWORD'), 
  security_token = Sys.getenv('SF_TOKEN')
)

`%notin%` <- Negate(`%in%`)

get_concept_tibble <- function(concept = NULL) {
  compound_fields <- sf_describe_object_fields(concept) %>% 
    .$compoundFieldName %>%
    unique() %>%
    na.omit()
  all_fields <- sf_describe_object_fields(concept) %>% 
    .$name
  get_fields <- all_fields[all_fields %notin% compound_fields]
  get_fields_txt <- paste(get_fields, collapse=", ")
  query_string <- paste0('SELECT ', get_fields_txt, ' FROM ', concept)
  tib <- sf_query_bulk(soql = query_string, guess_types = FALSE)
  return(tib)
}

dedup_concept_tibble <- function(tib = NULL, grouper = 'Organization__c') {
  tib_full <- tib %>% 
    mutate(
      updated_at = lubridate::as_datetime(SystemModstamp)
    )
  
  tib_current <- inner_join(
    tib_full %>% 
      group_by(across(starts_with(grouper))) %>% 
      summarise(
        latest_updated_at = max(updated_at)
      ), 
    tib_full, 
    by = c(grouper, 'latest_updated_at' = 'updated_at')
  )
  
  return(tib_current)
}

organizations <- get_concept_tibble(concept = 'Account')
evaluations <- get_concept_tibble(concept = 'Evaluation__c')
referrals <- get_concept_tibble(concept = 'Referral__c')
opportunities <- get_concept_tibble(concept = 'Opportunity') 
assessments <- get_concept_tibble(concept = 'Assessment__c')

```
