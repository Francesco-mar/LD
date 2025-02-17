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
library(data.table)
library(openxlsx)
library(downloadthis)
library(anytime)
library(zoo)

options(scipen=999)

rm(list = ls())

custom_date <- function() {
  today <- Sys.Date()
  return(format(today, format = "%d/%m/%Y"))
}


start_date <- "31/01/2012"
end_date <- custom_date()

PD_data <- pdfetch::pdfetch_BOE(c("LPMVTVC", "LPMVZQO", 
                                  "LPMB4TW", "RPMZM8B", 
                                  "RPMZM8J"), dmy(start_date), dmy(end_date))

PD_data <- as.data.frame(PD_data) 
PD_data['Date'] <- row.names(PD_data)
row.names(PD_data) <- NULL
colnames(PD_data) <- c("Mortgages", "Credit cards", 
                       "Other Consumer Credit", "SMEs", 
                       "Large Businesses", "Date")


PD_data$Date <- ymd(PD_data$Date)


PD_data <- PD_data %>% group_by(Date = format(as.yearqtr(Date, "%b-%Y"), "%YQ%q")) %>%
  summarise_all(sum) 

PD_data <- PD_data %>% relocate(Date)

PD_data_for_chart <- PD_data %>% pivot_longer(cols = 2:ncol(PD_data), names_to = "Type", values_to = "Lending(m)")

write.csv(PD_data_for_chart, "N:/BRD - Risks and Resilience/Personal folders/Francesco/Lending/Total_gross_lending_seasonally_adjusted.csv")

write.csv(PD_data_for_chart, "N:/BRD - Risks and Resilience/Topics/Lending Volumes/Total_gross_lending_seasonally_adjusted.csv")

