pacman::p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  matchmaker, # dictionary-based cleaning
  epikit,     # age_categories() function
  tidyverse   # data management and visualization
)


# IMPORT---------------
linelist_raw <- import("linelist_raw.xlsx")

#skimr::skim(linelist_raw)


linelist <- linelist_raw %>%
  
  
  janitor::clean_names()

rename(date_infection =infection_date,
       date_hospitalisation = hosp_date,
       date_outcome = date_of_outcome)
