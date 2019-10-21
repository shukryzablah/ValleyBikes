#' ---
#' title: "Stations"
#' author: "Emily Lachtara and Shukry Zablah"
#' 
## ----setup ------------------------------------------------
library(jsonlite)
library(sf)
library(tidyverse)

#' 
#' ## R Markdown
#' 
#' This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.
#' 
#' When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:
#' 
#' ###Importing the JSON Valley Bike File
#' The original JSON file contained more information than we anticipated for the 54 permanent stations: 
#' "code"                         "locking_station_type"         "sponsor"                     
#'  "secondary_locked_cycle_count" "id"                           "has_kiosk"                   
#'  "area"                         "opening_hours"                "schedule"                    
#'  "area_json"                    "area_type"                    "min_bikes_request_time"      
#' "installation_date"            "manage_status"                "stocking_high"               
#' "location"                     "serial_number"                "stocking_full"               
#' "type"                         "public"                       "status"                      
#' "station_stocking_status"      "photoid"                      "description"                 
#' "primary_locked_cycle_count"   "stocking_low"                 "total_locked_cycle_count"    
#' "free_spaces"                  "docking_station_type"         "cycles_in_station"           
#' "advertisement"                "address"                      "free_dockes"                 
#' "has_ccreader"                 "name"                         "notes"                       
#' "station_type"                 "kiosks"                       "max_extra_bikes"  
#' 
#' We originally looked to the nested DF area for information, but resorted to the location variable for our final table. We retained the arbitrary station serial number(from the website- not us), station name, address, latitude and longitude coordinates, and number of docks.  
#' 
## ------------------------------------------------------------------------
#IMPORTING JSON FILE FROM WEBSITE
valleybiketable <- fromJSON("https://valleybike.org/stations/stations/")

valleybiketable <- as_tibble(valleybiketable)


#SELECTING FOR VARIABLES
valleybikedf<-dplyr::select(valleybiketable,  serial_number,
                            address, name, stocking_full, location)

#CLEANING IT UP
stations<-valleybikedf%>%
  separate(location, into=c("latitude", "longitude"), sep=",")%>%
  mutate(longitude = parse_number(longitude))%>%
  mutate(latitude= parse_number(latitude))%>%
  mutate(serial_number =parse_number(serial_number))%>%
    rename(serial_num= serial_number, address=address,
           station_name=name, num_docks=stocking_full) %>%
    as_tibble()

#' 
## ---------------------------Update--------------------------

# reproducibility
set.seed(1)

# temporary solution, each station should already be classified into region
kmeans_res <- stations %>%
    select(latitude, longitude) %>%
    kmeans(centers = 6, nstart = 20)

# add the .cluster column to our original dataset
stations <- broom::augment(kmeans_res, stations)
# we are setting the community names manually here
community_names <- tibble(id = factor(seq(1, 6, 1))) %>%
    mutate(community_name = c("Holyoke", "Springfield", "Easthampton",
                              "South Hadley", "Amherst",
                              "Northampton"))

# adding the corresponding community name based on .cluster
stations <- stations %>%
    left_join(community_names, by = c(".cluster" = "id")) %>%
    select(-.cluster)

# save this data for use in the package
usethis::use_data(stations, overwrite = TRUE, compress = "gzip")


#' ------------------------------------------------------------------------
## ------------------------------------------------------------------------

# do voronoi tesselation to get regions for each community
communities <- kmeans_res %>%
    broom::tidy(col.names = c("latitude", "longitude")) %>%
    mutate(location = map2(longitude, latitude,
                           ~ st_point(c(.x, .y)))) %>%
    st_as_sf() %>%
    st_set_crs(NA) %>% # prevent warning on treating lat/lon
    st_union() %>%
    st_voronoi() %>%
    st_collection_extract() %>%
    st_as_sf() %>% 
    st_set_crs(4326) %>%
    mutate(id = factor(row_number())) %>%
    rename(location = x)

# manually name the communities
community_names <- tibble(id = factor(seq(1, 6, 1))) %>%
    mutate(community_name = c("Easthampton", "South Hadley",
                              "Northampton", "Amherst", "Holyoke",
                              "Springfield"))

# add the manual labels to the corresponding region
communities <- communities %>%
    left_join(community_names, by = "id")

# use in package
usethis::use_data(communities, overwrite = TRUE, compress = "gzip")


#' ------------------------------------------------------------------------
## ------------------------------------------------------------------------
