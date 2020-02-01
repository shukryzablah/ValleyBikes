.fetch_file <- function(file_path, output_dir, replace = FALSE, quiet = FALSE) {
    file_name <- basename(file_path)
    output_path <- file.path(output_dir, file_name)
    if(!file.exists(output_path) || replace) {
        utils::download.file(file_path, destfile = output_path, quiet = quiet)
    }
    return(output_path)
}


.fetch_date <- function(date, output_dir, replace = FALSE, quiet = FALSE) {
    root <- "https://nhorton.people.amherst.edu/valleybikes"
    prefix <- "VB_Routes_Data_"
    suffix <- ".csv.gz"
    file_name <- paste0(prefix, date, suffix)
    file_path <- file.path(root, file_name)
    output_path <- .fetch_file(file_path, output_dir, replace, quiet)
    return(output_path)
}

##' Fetch data from Valley Bike service for specified dates.
##'
##' Fetch data from Valley Bike service for specified dates. Provide a
##' start date and an endate as well as a place to save the files that
##' will be downloaded. The list of file paths for the downloaded
##' files are returned invisibly.
##' @title fetch_dates
##' @param start_date The string (yyyy-mm-dd) for start of queried range
##' @param end_date The string (yyyy-mm-dd) for end of queried range
##' @param output_dir An existing directory to store downloaded files
##' @param replace Boolean to overwrite existing files
##' @param quiet Boolean to omit download messages
##' @return invisible(output_paths) List of file paths to downloaded files
##'
##' @export
fetch_dates <- function(start_date, end_date, output_dir,
                        replace = FALSE, quiet = FALSE) {
    dates <- seq(from = lubridate::as_date(start_date),
                 to = lubridate::as_date(end_date),
                 by = "days")
    dates <- purrr::map_chr(dates,
                            ~ stringr::str_replace_all(.x, "-", "_"))
    output_paths <- purrr::map_chr(dates,
                                   ~ .fetch_date(.x, output_dir,
                                                 replace, quiet))
    return(invisible(output_paths))
}


