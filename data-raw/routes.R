## ------------------------------------------------------------------------
library(purrr)
library(data.table)
library(janitor)
library(dplyr)
library(fs)
library(usethis)
library(lubridate)


## ------------------------------------------------------------------------
extract_from_file <- function(file_path) {
    day <- file_path %>%
        data.table::fread(skip = 2) %>%
        janitor::clean_names() %>%
        group_by(route_id) %>%
        filter(date == max(date) | date == min(date)) %>%
        ungroup()
    return(day)
}

empty <- tibble(route_id = NA_character_,
                  bike = NA_real_,
                  date = NA_character_,
                  latitude = NA_real_,
                  longitude = NA_real_,
                  user_id = NA_character_)

possibly_extract_from_file <- possibly(extract_from_file, empty)


## ------------------------------------------------------------------------
extract_from_matching_files <- function(pattern = NULL) {
    file_names <- fs::dir_ls("./data-raw/", regexp = pattern)
    res <- file_names %>%
        map_dfr(possibly_extract_from_file)
    return(res)
}


## ------------------------------------------------------------------------
routes <- extract_from_matching_files("VB_Routes_Data_201._*")

routes <- routes %>%
    mutate(date = ymd_hms(date, tz = "EST", quiet = TRUE))

## ------------------------------------------------------------------------
usethis::use_data(routes, overwrite = TRUE, compress = "gzip")

