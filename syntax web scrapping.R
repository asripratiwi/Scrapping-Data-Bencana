message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url <- "https://dibi.bnpb.go.id/xdibi2?tb=1"
page <- read_html(url)

titles <- page %>% html_nodes(xpath = "//a[@data-toggle='popover']") %>% html_text()
dates <- page %>% html_nodes(xpath = "//small[@class='date text-danger']") %>% html_text()
links <- page %>% html_nodes(xpath = "//a[@data-toggle='popover']") %>% html_attr("onclick")


# titles <- page %>% html_nodes(xpath = '//a[@data-toggle='popover']') %>% html_text()
# dates <- page %>% html_nodes(xpath = '//small[@class='date text-danger']') %>% html_text()
# links <- page %>% html_nodes(xpath = '//a[@data-toggle='popover']') %>% html_attr("onclick")

data <- data.frame(
  time_scraped = Sys.time(),
  titles = head(titles, 5),
  dates = head(dates, 5),
  links = head(links, 5),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data)
rm(atlas_conn)