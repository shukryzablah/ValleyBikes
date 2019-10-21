## ------------------------------------------------------------------------
library(tidyverse)
library(rvest)


## ------------------------------------------------------------------------
page1 <- read_html("http://archive.northamptonma.gov/WebLink/0,0,0,0/fol/651572/Row1.aspx")
page2 <- read_html("http://archive.northamptonma.gov/WebLink/0,0,0,0/fol/651572/Row26.aspx")
page3 <- read_html("http://archive.northamptonma.gov/WebLink/0,0,0,0/fol/651572/Row51.aspx")


## ------------------------------------------------------------------------
get_file_paths_from_page <- function(page) {
    page %>%
        html_nodes(".DocumentBrowserCell") %>%
        html_nodes("a") %>%
        html_attr("href") %>%
        map(function(x) paste0("http://archive.northamptonma.gov/WebLink/", x)) %>%
        flatten_chr()
}


## ------------------------------------------------------------------------
file_paths <- c(get_file_paths_from_page(page1),
               get_file_paths_from_page(page2),
               get_file_paths_from_page(page3))


## ------------------------------------------------------------------------
download_from_archive <- function(path, name) {
    name <- str_split(path, '/') %>% flatten_chr() %>% last()
    download.file(path, paste0("../data-raw/", name))
}


## ---- eval=FALSE---------------------------------------------------------
## file_paths %>%
##     walk(download_from_archive)


## ------------------------------------------------------------------------
slow_download_from_archive <- slowly(download_from_archive,
                                     rate = rate_delay(420),
                                     quiet = FALSE)

file_paths %>%
    walk(slow_download_from_archive)

