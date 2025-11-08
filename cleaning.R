pacman::p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  parsedate,
  aweek,
  matchmaker, # dictionary-based cleaning
  epikit,     # age_categories() function
  tidyverse   # data management and visualization
)


# IMPORT---------------
linelist_raw <- import("linelist_raw.xlsx")

skimr::skim(linelist_raw)

linelist <- linelist_raw %>%

  janitor::clean_names() %>% 

rename(date_infection = infection_date,
       date_hospitalisation = hosp_date,
       date_outcome = date_of_outcome) %>% 
# deduplication
  distinct() %>% 

# remove columns
select(-c(date_onset, fever:vomit)) %>% 

# add BMI column
mutate(
  bmi = wt_kg / (ht_cm/100)^2,
# create displayed text column
  new_var_paste = stringr::str_glue("This patient came to {hospital} on ({date_hospitalisation})")) %>% 
  ## split columns
   ### split = stringr::str_split_fixed(new_var_paste, "on", 2)
 
  
 mutate(
   hospital = recode(hospital, 
                     "Central Hopital" = "Central Hospital",
                     "Military Hopital" = "Military Hospital",
                     "Mitylira Hopital" = "Military Hopital",
                     "Mitylira Hospital" = "Military Hopital",
                     "Port Hopital" = "Port Hospital",
                     "St. Marks Maternity Hopital (SMMH)" = "St. Mark's Maternity Hospital (SMMH)"
                     )
 ) %>% 
  
  mutate(hospital = replace_na(hospital, "Missing")) %>% 
  
  # create age_years column (from age and age_unit)
  mutate(age_years = case_when(
    age_unit == "years" ~ age,
    age_unit == "months" ~ age/12,
    is.na(age_unit) ~ age)) %>% 
  
  mutate(
    # age categories: custom
    age_cat = epikit::age_categories(age_years, breakers = c(0, 5, 10, 15, 20, 30, 50, 70)),
    
    # age categories: 0 to 85 by 5s
    age_cat5 = epikit::age_categories(age_years, breakers = seq(0, 85, 5)))
