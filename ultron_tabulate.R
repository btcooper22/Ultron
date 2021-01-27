# Packages
require(tidyr)
require(dplyr)
require(magrittr)
require(readxl)
require(foreach)
require(readr)

# Load
file <- "Guide.xlsx"
films <- read_xlsx(file, 1)
pool <- read_xlsx(file, 2)
vars <- read_xlsx(file, 3)

# Produce full list
films_unique <- unique(films$Film)
full_rules <- foreach(i = 1:length(films_unique),
        .combine = "rbind") %do%
  {
    # Extract title-only rules
    title <- films_unique[i]
    title_only <- films %>% 
      filter(Film == title) %>% 
      select(2:3)
    
    # Extract applicable variables
    valid_vars <- vars %>% 
      filter(Film == title) %>% 
      pivot_longer(2:ncol(vars)) %>% 
      filter(value == "Y")
    
    # Extract applicable rules
    valid_rules <- pool %>% 
      filter(Requires %in% valid_vars$name) %>% 
      select(c(1,3))
    
    # Prepare output
    tibble(Film = title,
           rbind(title_only,
                 valid_rules))
    
  }

# Tabulate
tabulated <- full_rules %>% 
  na.omit() %>% 
  group_by(Film, Class) %>% 
  summarise(n = n()) %>% 
  pivot_wider(names_from = "Class",
              values_from = "n") %>% 
  select(1,3,2,4)

# Write
write_csv(tabulated, "UltronTabulated.csv")
full_rules %>% 
  na.omit() %>% 
  write_csv("UltronRules.csv")