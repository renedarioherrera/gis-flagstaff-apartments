library(here)
library(tidyverse)
library(janitor)

# read 
apartment_list <- read_csv(file = "../../Dropbox/Documents/flagstaff-housing-list.csv") %>%
  clean_names()

# inspect
glimpse(apartment_list)

# transform
apartment_list <- apartment_list %>%
  mutate(
    description = factor(description),
    rent_total = rent_base + rent_pet,
    price_per_area = rent_total / sq_ft,
    fees_total = deposit_refundable + fees_nonrefundable,
    total_6_month = fees_total + (rent_total * 6),
    total_9_month = fees_total + (rent_total * 9),
    total_12_month = fees_total + (rent_total * 12)
  ) 

# save data 
write_rds(
  x = apartment_list,
  file = "data/apartment-list.rds"
)
