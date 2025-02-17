library(dplyr)
library(pdfetch)
library(tidyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(boeCharts)
library(tidyr)
library(tidyverse)
library(data.table)
library(openxlsx)
library(downloadthis)
library(anytime)
library(zoo)
library(FAMEr)

rm(list = ls())

#source("data_input_info/libraries.R")

options(scipen=999)

custom_date <- function() {
  today <- Sys.Date()
  return(format(today, format = "%d/%m/%Y"))
}


start_date <- "31/01/2012"
end_date <- custom_date()


FAME_codes <- read.csv("N:/BRD - Risks and Resilience/Personal folders/Francesco/Lending/codes_acs_flows_new.csv")
codes <- FAME_codes$fame_code

FAME_data <- readFAMEMultiple(codes, dmy(start_date), dmy(end_date)) %>% tibble

volumes_data <- FAME_data %>% 
  setnames(old = FAME_codes$fame_code, new = FAME_codes$label)

volumes_data_q_flow <- volumes_data %>% 
  group_by(Date = format(as.yearqtr(Date, "%b-%Y"), "%YQ%q")) %>%
  summarise_all(sum) 

volumes_data_q_flow <- pivot_longer(volumes_data_q_flow, cols = 2:ncol(volumes_data_q_flow),
                                    names_to = "Type",
                                    values_to = "Lending.m.")

write.csv(volumes_data_q_flow, "N:/BRD - Risks and Resilience/Personal folders/Francesco/Lending/fame_data_acs_flows.csv")

write.csv(volumes_data_q_flow, "N:/BRD - Risks and Resilience/Topics/Lending volumes/acs_flows_data.csv")
