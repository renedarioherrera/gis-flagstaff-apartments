# packages 
library(here)
library(tidyverse)
library(janitor)
library(sf)
library(tidygeocoder)
library(tigris)

# options 
options(tigris_use_cache = TRUE)

# get place boundaries 
az_places <- places(
  state = "AZ"
) %>%
  clean_names()

# flagstaff boundary
flagstaff_sf <- az_places %>%
  filter(name == "Flagstaff")

bounding_box <- st_as_sfc(st_bbox(flagstaff_sf))

# get roads 
roads_sf <- primary_secondary_roads(
  state = "AZ"
) %>%
  clean_names()

flagstaff_roads <- st_intersection(
  x = bounding_box,
  y = roads_sf
)

# read data
apartment_list <- read_rds("data/apartment-list.rds")

# inspect 
glimpse(apartment_list)

# geocode address
apartment_list_geocoded <- apartment_list %>%
  geocode(
    street = address,
    city = city,
    state = state,
    postalcode = zip,
    method = 'osm', 
    lat = latitude , 
    long = longitude)

# plot 
ggplot() +
  geom_sf(data = flagstaff_sf, fill = "yellow") +
  geom_sf(data = flagstaff_roads, color = "green", size = 3, alpha = 2/9) +
  geom_point(data = apartment_list_geocoded,
              mapping = aes(
                x = longitude, 
                y = latitude,
                size = price_per_area),
             alpha = 1/3) +
  labs(
    title = "Apartments",
    subtitle = "Flagstaff",
    size = "Price per Square Foot"
  ) +
  theme_void()
